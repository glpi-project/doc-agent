Network discovery
=================

A network discovery task aims to scan the the network and reports devices
found to the GLPI server, so they can be added to the list of known assets.

Once part of the list of known assets, further information can be retrieved
from SNMP enabled devices using :doc:`network-inventory`.

Overview
--------

This task uses the following protocols to scan IP networks:

* Arp local table request with ``arp -a`` command or ``ip neighbor show`` command
* ICMP Echo (aka ping) with fallback on ICMP Timestamp scan [#f1]_
* NetBIOS scan (if ``Net::NBName`` is available and proper credits provided)
* SNMP scan (if ``Net::SNMP`` is available, and proper credits provided)

Any device replying to at least one of those protocols will be *discovered*,
with minimal information, such as mac address and hostname.

Additionally, if the device replies to SNMP, the agent will attempt to identify
it using various methods.

The primary method relies on retrieving the value of
the dedicated SNMP variable (``SNMPv2-MIB::sysObjectID.0``), which is a
constructor-specific OID identifying a given device model, and comparing it to
the agent internal database (the ``sysobject.ids`` file, described in :ref:`sysobject.ids`).

If a match is found, model, type and
manufacturer are added to the information reported to the GLPI server, allowing
simple identification. If no match is found, various heuristics are performed
in order to identify the device, with lower reliability.

A secondary method relies on GLPI Agent ``MibSupport`` feature which permits to implement
dedicated perl module for any kind of device. As an example, when the sysObjectID
is reported as **linux** with the ``8072.3.2.10`` model-specific suffix, the ``LinuxAppliance``
**MibSupport** module usage is triggered and permits to inventory Synology or Ubiquiti devices.

Discovered devices are then reported to the GLPI servers, where import
rules are applied. Devices not matching any import
criteria will be kept in a server list of ignored devices.

Running
-------

Pre-requisite
^^^^^^^^^^^^^

The agent performing the task needs to have the **netdiscovery** module installed.

The agent performing the task needs network access the target networks, with
forementioned protocols, as well as control access, for SNMP: just being able
to send UDP packets to a device is not enough, if this device is configured to
ignore them. It is even best to use an agent from the same network than the scanned
devices so it can access the local system arp table.

.. _snmpv3-caution:

.. caution::

   If a device requires SNMP v3 access, you may need to install **Crypt::Rijndael** perl module.
   This module is not installed by default with the agent on linux systems. On a debian-based
   system, you just have to run ``apt install libcrypt-rijndael-perl``. On a RPM-based system,
   running ``dnf install perl-Crypt-Rijndael`` is the right command.

As for any other server controlled task, the agent should use either managed or
half-managed mode, as explained in :ref:`execution-modes`. If
the task is server-triggered, the agent must run in managed mode, and
its HTTP port should be reachable from the server.

Command-line execution
^^^^^^^^^^^^^^^^^^^^^^

A network discovery task can be also performed without a GLPI server, allowing
easier control and troubleshooting, with the :doc:`../man/glpi-netdiscovery` command-line tool.

However, this command generates files which will have to be injected in GLPI server
using :doc:`../man/glpi-injector` command.

Efficiency concerns
^^^^^^^^^^^^^^^^^^^

Credentials
***********

Unfortunately, there is no way to distinguish a failed SNMP authentication
attempt on a device from the absence of a device. It means the agent will try
each available credential against each IP address, in given order, and wait
for timeout each time. The most efficient way to address this issue if to only
use the relevant set of credentials, and reduce the specific SNMP timeout.

Threads number
**************

In order to scan multiple addresses simultaneously, the agent can use multiple
discovery threads. This allow multiple simultaneous request, but also increase
resource usage on agent host.

.. _advanced-configuration:

Advanced Configuration
----------------------

Since GLPI-Agent 1.14, glpi-agent can use a dedicated configuration file to tune the way
snmp discovery works. The file is named ``snmp-advanced-support.cfg`` and you should
create the ``snmp-advanced-support.local`` which is by default included from the ``.cfg``
file to update the configuration.

As of 1.14, you can only change one configuration value: ``oids``

.. _oids:

``oids``
   ``oids`` is a comma-separated list of oids used during session testing. All oids will be requested
   and only one has to respond to validate a snmp session. If none provides any answer, this will mean
   there's no device or the device is not reachable.

   The default is to only check for device sysDescr (``.1.3.6.1.2.1.1.1.0``). It means netdiscovery task
   will only discover by default snmp devices supporting this oid.

   Fortunately, a manufacturer may decide to not support that standard oid. If this is the case, you can add
   a well-known supported oid to make your device discovered. As an example, this is exactly the case for
   Snom IP phones and you can simply add ``.1.3.6.1.2.1.7526.2.4`` as described in the default advanced
   configuration.

.. _troubleshooting:

Troubleshooting
----------------

1. **The task doesn't run at all**

   a) The agent may be lacking the NetDiscovery module: run ``glpi-agent --list-tasks`` to check installed modules.
   b) There may be a server/agent communication issue: check you can reach the agent port (62354 by default) from the server host.
   c) The agent may be ignoring server requests, due to a a trust issue: check the agent logs for ``[http server] invalid request (untrusted address)`` message.

#. **The task runs, but agent logs show that SNMP is not used**

   a) The agent may be lacking the required Net::SNMP perl module: run ``perl -MNet::SNMP`` on agent host to check, it should blocks.
   b) There may be no SNMP credentials associated to the network scanned.

#. **The task runs, but no devices get added to my inventory**

   The reported items are insufficiently identified to be imported, according to
   your current import rules, check the list of ignored devices and the list of import rules on server side.

#. **The task runs, but my SNMP devices are not properly identified**

   The agent probably lacks the device SNMP identifier in its internal database.

   Use :doc:`../man/glpi-netdiscovery` executable with debug option on the device,
   get the value from its output, and add it to the ``sysobject.ids`` file, as
   described in :ref:`sysobject.ids` to fix the issue.

   .. prompt:: bash

      glpi-netdiscovery --first 192.168.0.1 --last 192.168.0.1 --credentials version:2c,community:public --debug

   Output::

      ...
      [debug] partial match for sysobjectID .1.3.6.1.4.1.311.1.1.3.1.1 in database: unknown device ID
                                                         ^^^^^^^^^^^^^

#. **Agent crashes**

   This is likely to be a TLS multithreading issue. They are multiple ways to
   reduce the probability of such crash:

   a) make sure you only have one TLS perl stack installed on the agent host,
      preferably ``IO::Socket::SSL`` + ``Net::SSLeay``. Having both stacks at once
      (``IO::Socket::SSL`` + ``Net::SSLeay`` vs ``Net::SSL`` + ``Crypt::SSLeay``) usually leads to
      unexpected results, even without thread usage
   b) use latest upstream release of ``IO::Socket::SSL``, even if your distribution
      doesn't provide it
   c) reduce threads number during network discovery tasks

   However, the only actual solution currently is to disable SSL completely, using
   plain HTTP for agent/server communication. If the agent run on server host,
   that's usually not really a problem.

.. rubric:: Footnotes

.. [#f1] For ICMP Echo & ICMP timestamp definition, see `RFC 792 <https://www.rfc-editor.org/rfc/rfc792.html>`_:

   - ICMP Echo messages have type 8 for requests and 0 for answers.
   - ICMP Timestamp messages have type 13 for requests and 14 for answers.
