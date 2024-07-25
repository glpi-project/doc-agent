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
But the short way to enable it with minimal security is to run from an administrator console:

.. prompt:: batch

   winrm quickconfig
   winrm set winrm/config/service/auth @{Basic="true"}
   winrm set winrm/config/service @{AllowUnencrypted="true"}

If you're using PowerShell, you need to enclose the confguration value in single quotes, such as this:

.. prompt:: batch

   winrm set winrm/config/service/auth '@{Basic="true"}'
   winrm set winrm/config/service '@{AllowUnencrypted="true"}'

You may probably need to also create a dedicated user with administrative privileges and enable the ``windows remote management`` firewall rule.

For WinRM, GLPI Agent must be able to make network http requests on WinRM dedicated ports, by default 5985 for HTTP and 5986 for HTTPS. The remote WinRM user **must** have administration privileges.

.. hint::

   **WinRM** remote inventory can be run from an agent running on unix/linux platform.

Setup
-----

Remote computers will be known as **remotes** on GLPI agent side.

.. _remote-targets:

Targets
^^^^^^^

A remote will have to be associated to a target which can be a GLPI server or a local directory. The target to use will have to be specified by its alias, like ``server0``, ``local0`` or ``server1``.
Only previously known targets can be used. So to define a new target, first run glpi-agent with the required target.

You can check what are known targets by running:

.. prompt:: bash

   glpi-remote list targets

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

Without remote registration
^^^^^^^^^^^^^^^^^^^^^^^^^^^

You also can use the ``--remote`` option of :doc:`../man/glpi-agent` to process a remote without registering it:

.. prompt:: bash

   glpi-agent --remote=ssh://admin:pass@192.168.43.237 --logger=stderr --tasks remoteinventory

``--remote`` option can be handy to schedule a remote inventory via crontab or windows job scheduling.

.. hint::

   ``--remote`` value can be a list of remote url separated by commas. So commas are prohibited in passwords.

Performance with X remotes defined
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

By default, only one remote inventory can be run at a time.

Since GLPI-Agent 1.5, you can use ``--remote-workers`` option to set the maximum number of worker the remote inventory task can run at the same time, each worker processing one remote.

For example, the following command will process 2 remote inventory at the same time:

.. prompt:: bash

   glpi-agent --remote-workers=2 --remote=ssh://192.168.43.237,ssh://192.168.77.252 --logger=stderr --tasks remoteinventory

Modes
^^^^^

In some context, you may need to change the way remote inventory is processed. In that case, you can configure your remote to use modes.

Modes must be set with the remote url itself to only be applied on one remote. The syntax is similar to the URL query string one by adding ``?mode=xxxx`` where **xxxx** is the mode to use.

For **winrm**, only one mode can be used to require SSL access to remote: ``mode=ssl``.

For example, the following command will process a winrm remote inventory over SSL (default port becomes 5986):

.. prompt:: bash

   glpi-agent --remote=winrm://admin:pass@192.168.47.237?mode=ssl --logger=stderr --tasks remoteinventory

For **ssh**, 3 modes are available:

 1. ``mode=perl`` can be set if perl is available on the remote to try using it for few specific cases (fqdn and domain),
 2. ``mode=ssh`` can be set to not try to use **libssh2** for remote access,
 3. ``mode=libssh2`` can be set to not try to use **ssh** command access if **libssh2** fails.

You can combine modes. To do so, you just need to concatenate them using the underscore sign as separator: ``mode=perl_ssh`` or ``mode=ssh_perl`` are valid syntax

By default, the **ssh** mode is: ``mode=libssh2_ssh``. So you don't need to specify both and they are still set if **perl** mode is set.
**libssh2** and **ssh** modes only need to be used if you have an issue with the other mode.

For example, the following command will process a ssh remote inventory using only libssh2 and enabling perl mode:

.. prompt:: bash

   glpi-agent --remote=ssh://admin:pass@192.168.43.237?mode=perl_ssh --logger=stderr --tasks remoteinventory

Caveats
-------

As the inventory is run remotely, you may not obtain exactly the same inventory as if the agent was run locally.

For ``winrm`` remotes, the informations may miss or may differ from locally run inventory:

 * software installation date,
 * bios informations (as we can't run dmidecode),
 * devices name, type or description (mostly not localized via winrm),
 * databases services.

For ``ssh`` remotes, the informations may miss or may differ from locally run inventory:

 * printers,
 * databases services.
