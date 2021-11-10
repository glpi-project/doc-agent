Remote inventory
================

GLPI Agent supports to run computer inventory remotely, this feature can also be referenced as **Agent-less inventory** for targeted computers.

Overview
--------

This task can inventory remote computers via:

* **ssh**: for unix/linux computers
* **WinRM**: for win32 computers

Pre-requisite
^^^^^^^^^^^^^

To remotely inventory unix/linux computers supporting ssh, GLPI Agent needs to make network requests on ssh port. The remote ssh user **must** have administration privileges.

For windows computers, WinRM **must** be enabled on targeted computers. You can follow `Microsoft official documentation <https://docs.microsoft.com/en-us/windows/win32/winrm/installation-and-configuration-for-windows-remote-management>`_ to enable WinRM.
But the short way to enable it with minimal security is to run from an administion console:

.. prompt:: batch

   winrm quickconfig
   winrm set winrm/config/service/auth @{Basic="true"}
   winrm set winrm/config/service @{AllowUnencrypted="true"}

You may probably need to also create a dedicated user with administrative privileges and enable the ``windows remote management`` firewall rule.

For WinRM, GLPI Agent must be able to make network http requests on WinRM dedicated ports, by default 5985 for HTTP and 5986 for HTTPS. The remote WinRM user **must** have administration privileges.

.. hint::

   **WinRM** remote inventory can be run from an agent running on unix/linux platform.

Setup
-----

Remote computers will be known as **remotes** on GLPI agent side.

.. _remote-registration:

Remote registration
^^^^^^^^^^^^^^^^^^^

So before running inventory, you'll have to register in GLPI Agent environment remote computers with dedicated credentials. This step can be done by :doc:`../man/glpi-remote` script using the **add** sub-command.

This is as simple as running:

.. prompt:: bash

   glpi-remote add ssh://admin:pass@192.168.43.237

or

.. prompt:: bash

   glpi-remote add winrm://admin:pass@192.168.48.250 --target server0

.. note::

   When add a remote supporting WinRM, the agent will test provided credential and will fail if something goes wrong. You can avoid this check using ``-C`` or ``--no-check`` option.

Managing remotes
^^^^^^^^^^^^^^^^

After remotes has been registered, you can list them with the following command:

.. prompt:: bash

   glpi-remote list

This will provides the locally known remotes:

.. code-block:: text

   index  deviceid                 url                                      target   Next run date
       1  WIN-2020-09-23-15-37-52  winrm://glpi-agent:****@192.168.100.138  server0  Tue Nov  9 15:46:51 2021
       2  XPS-2021-11-10-15-10-16  winrm://glpi-agent:****@192.168.100.139  server0  on next agent run

You can delete a remote giving its listing index:

.. prompt:: bash

   glpi-remote delete 1

You can update credential by simply :ref:`register again <remote-registration>` the remote as the script will recognize your are updating an existing **remote**.

.. attention::

   As of this writing, no solution has still been implemented in GLPI to manage remotes.
   So everything has to be done from the console.

Running
-------

Automatic execution
^^^^^^^^^^^^^^^^^^^

When run as a service or a daemon and once remotes are registered against GLPI Agent and associated to a target, the agent will run RemoteInventory task when expected, generate an inventory and submit it to the related server or store it to a local path.

The selected target must be a known target:

 * if selected target is ``server0``, ``server`` must be defined in configuration,
 * if selected target is ``server1``, ``server`` must be defined with at least 2 URLs as ``server1`` means to use the second URL,
 * if selected target is ``local0``, ``local`` must be set in configuration with an existing path.

Command-line execution
^^^^^^^^^^^^^^^^^^^^^^

When GLPI Agent is run from the commandline, it will try to run RemoteInventory task if at least one **remote** is known. It will then select one **remote** and only one to run an inventory but only if its ``Next run date`` has been set to ``on next agent run``.

You can try to run only RemoteInventory task with:

.. prompt:: bash

   glpi-agent --logger=stderr --tasks remoteinventory

You may have to run again the agent if another **remote** is expected to be inventoried. Just run ``glpi-remote list`` to verify if a **remote** has to be inventoried.
