Network discovery
=================

A network discovery task aims to scan the the network, and reports devices
found to the GLPI server, so they can be added to the list of known assets.

Once part of the list of known assets, further information can be retrieved
from SNMP enabled devices using :doc:`network-inventory`.

Overview
--------

This task uses the following protocols to scan IP networks:

* ICMP scan (if ``nmap`` is available)
* NetBIOS scan (if ``Net::NBName`` is available and proper credits provided)
* SNMP scan (if ``Net::SNMP`` is available, and proper credits provided)

Any device replying to at least one of those protocols will be *discovered*,
with minimal information, such as mac address and hostname.

Additionally, if the device replies to SNMP, the agent will attempt to identify
it using various methods

The primary method relies on retrieving the value of
the dedicated SNMP variable (``SNMPv2-MIB::sysObjectID.0``), which is a
constructor-specific OID identifying a given device model, and comparing it to
the agent internal database (the ``sysobject.ids`` file, described in :doc:`../database`.

If a match is found, model, type and
manufacturer are added to the information reported to the GLPI server, allowing
simple identification. If no match is found, various heuristics are performed
in order to identify the device, with lower reliability.

Discovered devices are then reported to the GLPI servers, where import
rules are applied. Devices not matching any import
criteria will be kept in a server list of ignored devices.

Running
-------

Pre-requisite
^^^^^^^^^^^^^

The agent performing the task needs to have the network discovery module
installed. Many Linux distributions ships agent modules in distinct packages.

The agent performing the task needs network access the target networks, with
forementioned protocols, as well as control access, for SNMP: just being able
to send UDP packets to a device is not enough, if this device is configured to
ignore them.

As for any other server controlled task, the agent should use either managed or
half-managed mode, as explained in :doc:`agent usage <../usage>`. If
the task is server-triggered, the agent must run in managed mode, and
its HTTP port should be reachable from the server.

Command-line execution
^^^^^^^^^^^^^^^^^^^^^^

A network discovery task can be also performed without a GLPI server, allowing
easier control and troubleshooting, with the ``glpi-netdiscovery`` command-line tool.

However, there is no way currently to inject the result in GLPI.

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
resource usage on agent host. And also increase crash probability, if TLS is
used in any manner (including agent/server communication through HTTPS), as
perl TLS bindings are not 100% thread-safe. Unfortunately, there is no way
currently to avoid thread usage totally, as current implementation always use
one controlling threads, in addition to a configurable number of working
threads.

.. _troubleshoot:

Troubleshooting
----------------

The task doesn't run at all
^^^^^^^^^^^^^^^^^^^^^^^^^^^

* The agent may be lacking the Net Discovery module: run ``glpi-agent --list-tasks`` to check.
* There may be a server/agent communication issue: check you can reach the agent port (62354 by default) from the server host.
* The agent may be ignoring server requests, due to a a trust issue: check the agent logs for ``[http server] invalid request (untrusted address)`` message.

The task runs, but agent logs show than SNMP is not used
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* The agent may be lacking the required Net::SNMP perl module: run ``perl -MNet::SNMP`` on agent host to check, it should blocks.
* There may be no SNMP credentials associated to the network scanned.

The task runs, but no devices get added to my inventory
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The reported items are insufficiently identified to be imported, according to
your current import rules, check the list of ignored devices and the list of import rules on server side.

The task runs, but my SNMP devices are not properly identified
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The agent probably lacks the device SNMP identifier in its internal database.

Use ``glpi-netdiscovery`` executable with debug option on the device,
get the value from its output, and add it to the ``sysobject.ids`` file, as
described in :doc:`../database` to fix the issue.

.. code-block:: shell

    $ glpi-netdiscovery --first 192.168.0.1 --last 192.168.0.1 --credentials version:2c,community:public --debug
    ..
    [debug] partial match for sysobjectID .1.3.6.1.4.1.311.1.1.3.1.1 in database: unknown device ID
                                                       ^^^^^^^^^^^^^

Agent crashes
^^^^^^^^^^^^^

This is likely to be a TLS multithreading issue. They are multiple ways to
reduce the probability of such crash:

* make sure you only have one TLS perl stack installed on the agent host,
  preferably ``IO::Socket::SSL`` + ``Net::SSLeay``. Having both stacks at once
  (``IO::Socket::SSL`` + ``Net::SSLeay`` vs ``Net::SSL`` + ``Crypt::SSLeay``) usually leads to
  unexpected results, even without thread usage
* use latest upstream release of ``IO::Socket::SSL``, even if your distribution
  doesn't provide it
* reduce threads number during network discovery tasks

However, the only actual solution currently is to disable SSL completely, using
plain HTTP for agent/server communication. If the agent run on server host,
that's usually not really a problem.