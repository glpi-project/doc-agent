IDS Databases
=============

The agent integrates IDS databases which are located in agent data directory. It consists of the following files:

* ``pci.ids`` is a database of PCI devices, used by local inventory module,
* ``usb.ids`` is a database of USB devices, used by local inventory module,
* ``edid.ids`` is a database of Screen manufacturer, used by local inventory module,
* ``sysobject.ids`` is a database of SNMP devices, used by network discovery and
  network inventory tasks modules.

Those files can easily be customized if needed, as their format is
self-documented. However, local modifications will get lost on upgrade.

.. _sysobject.ids:

SNMP device IDS database
^^^^^^^^^^^^^^^^^^^^^^^^

The ``sysobject.ids`` file is a database of known SNMP devices, indexed by the
discriminant part of their sysObjectID [#f1]_ value:

::

    9.1.1111    Cisco   NETWORKING      Catalyst 3500
    +           +       +               +
    |           |       |               |
    |           |       |               +-> device model
    |           |       |
    |           |       +-----------------> device type
    |           |
    |           +-------------------------> device manufacturer
    |
    +-------------------------------------> sysObjectID model-specific suffix

The **sysObjectID model-specific suffix** is the last part of the full sysObjectID value, ie:

::

    .1.3.6.1.4.1.9.1.111
    +            +
    |            |
    |            +-----> model-specific suffix
    |
    +------------------> shared prefix

The sysObjectID value for any SNMP device can be retrieved by any SNMP client,
using its OID (``.1.3.6.1.2.1.1.2.0``), or with either :doc:`tasks/network-inventory` or :doc:`tasks/network-discovery`
command-line tools, with ``--debug`` flag.

.. rubric:: Footnotes

.. [#f1] See sysObjectID definition in `RFC 3418 <https://www.rfc-editor.org/rfc/rfc3418.html>`_:

    sysObjectID is the vendor's authoritative identification of the network management
    subsystem contained in the entity. This value is allocated within the SMI enterprises
    subtree (1.3.6.1.4.1) and provides an easy and unambiguous means for determining
    *what kind of box* is being managed.
