ToolBox interface
=================

**ToolBox** is a simple web interface embedded into GLPI Agent that allows users to configure some features when there is no GLPI server available.

.. cssclass:: no-bottom-margin

For example:

* When you have an isolated network that cannot or should not be connected to a GLPI Server or via GLPI Agent :doc:`proxy-server-plugin` for any reason but you still need to run a network discovery or a network inventory.
* When you need to review and update the inventory with custom fields which can be setup using a YAML file exported from `GLPI Fields plugin <https://github.com/pluginsGLPI/fields>`_.

.. cssclass:: no-bottom-margin

Here are the main features **ToolBox** provides:

* manage inventory task jobs (available since GLPI Agent 1.6)
* manage credentials definitions
* manage ip range definitions
* manage scheduling definitions (available since GLPI Agent 1.6)
* display light inventory results and eventually edit custom fields
* manage remotes definition (deprecated since GLPI Agent 1.6)
* manage mibsupport rules to tune the results for SNMP network devices

.. note::

   **ToolBox** is not intended to replace a plugin like `GlpiInventory <https://github.com/glpi-project/glpi-inventory-plugin/>`_
   or `FusionInventory for GLPI <https://github.com/fusioninventory/fusioninventory-for-glpi>`_ plugins
   but can be helpful where none of these plugin can or should be used for any reason.

.. seealso::

   Don't miss the `Unlocking Efficient Network Inventory Management with the GLPI Agent Toolbox Plugin <https://glpi-project.org/unlocking-efficient-network-inventory-management-with-the-glpi-agent-toolbox-plugin/>`_
   blog post including this demo video by Arthur Schaefer:

   ..  youtube:: xNfqKTp9LN8

Again **ToolBox** is mainly a GLPI-Agent based tool allowing to run a netscan tasks over a network only using a glpi-agent and a browser.
Netscan task is firstly used to discover and inventory networks devices or printer supporting SNMP,
but now (available since GLPI Agent 1.6), it also supports to discover and inventory computers like ESX, Unix/Linux supporting ssh and windows computers supporting WinRM using :doc:`RemoteInventory task <../tasks/remote-inventory>`.

Run tasks results can be stored in the agent environment and you can browse them on **Results** dedicated pages. But (available since GLPI Agent 1.6) you can also simply and directly send them to a GLPI server, without storing them locally.
You can indeed select as job target any glpi-agent configured target (local or server) or the local glpi-agent installation folder.

.. note::

   Since GLPI Agent 1.5, **ToolBox** also permits to manage :doc:`RemoteInventory task <../tasks/remote-inventory>` by defining and updating remotes.
   It can also be used to expire remotes and require a remoteinventory task run to handle any expired remotes right now.
   The interface is really basic: it doens't show the status of a remote and you'll still have to audit your agent log
   if some remotes are failing to upload an inventory in GLPI.

   For this reason, and as GLPI Agent 1.6 will provide a netscan feature supporting RemoteInventory task, the remotes page is **deprecated**
   and will be *removed* in a future version.

Setup
*****

.. cssclass:: no-bottom-margin

By default, **this plugin is disabled**. So the first required step is to enable it creating a dedicated configuration:

#. Locate the ``toolbox-plugin.cfg`` file under the GLPI agent :ref:`configuration folder <system-location>` [#f1]_,
#. **Make a copy** - avoid renaming it - of this file in the same folder by just changing the file extension from ``.cfg`` to ``.local``.
#. Edit the ``toolbox-plugin.local`` and set ``disabled`` to ``no`` and comment or remove the ``include`` directive at the end
#. Restart the glpi-agent service

This way, the agent will start to accept toolbox requests on its current port and on ``/toolbox`` as base url, by default: `http://127.0.0.1:62354/toolbox`

.. warning::

   By default, anybody can access this feature after it has been enabled. You should first set ``forbid_not_trusted = yes`` in your ``toolbox-plugin.local``
   to enable a "by trusted IP address" filtering, authorizing IP only enabled with the :ref:`httpd-trust` option.

   You **MUST** not enable **ToolBox** on an unsecure network.

   Also, **since GLPI Agent 1.5**, you can enable :doc:`basic-authentication-server-plugin`
   and :doc:`ssl-server-plugin` to completely secure the **ToolBox** interface.

By default, you have a very restricted interface displayed on the first access.
But you can edit everything under the setup page clicking on the top right gear icon. That is where you can activate additional pages in the ``Navigation bar`` section.

.. cssclass:: no-bottom-margin

You should enable the following pages:

#. :ref:`Credentials <toolbox-credentials>`: to manage SNMP credentials, ESX user/password, SSH and WinRM credentials for RemoteInventory netscan
#. :ref:`Inventory <inventory-tasks>`: to configure and manage jobs for local or netscan inventory tasks
#. :ref:`IP Ranges <toolbox-ip-ranges>`: to manage ip ranges and to define credentials to use on each one
#. :ref:`Scheduling <toolbox-scheduling>`: to define scheduling to be used by inventory jobs

You can disable the **Results** page if your glpi-agent will directly submit inventories to a GLPI server and you won't use the local agent installation folder as target.

.. note::

   After you have configured your interface, you can disable any further online configuration to avoid mistake by disabling the ``Configuration update authorized`` checkbox in the ``Toolbox plugin configuration`` section.

   If you need to tune again the configuration, you need to edit the ``toolbox.yaml`` file and change the ``updating_support`` line in the ``configuration`` section like:

   ::

      configuration:
         updating_support: yes

.. _toolbox-credentials:

Credentials
***********

.. cssclass:: no-bottom-margin

Initially, the credentials page will show you it found no credential:

.. image:: /_static/images/credentials.png

So it essentially gives you access to the ``Add Credential`` button.

Create a credential
"""""""""""""""""""

.. cssclass:: no-bottom-margin

You can quickly create a new credential after you have clicked on the ``Add Credential`` button on the Credentials list page:

.. image:: /_static/images/credentials-new.png

.. cssclass:: no-bottom-margin

You have then a simple form permitting you to set a **Name**, choose a **Type** and when applicable:

#. Set the SNMP version
#. Set the SNMP community
#. Set the SNMP port if different than the default 161
#. Set the SNMP protocol, the default beeing *udp*
#. Set the SNMP username for SNMP v3
#. Set the SNMP authentication password for SNMP v3
#. Set the SNMP authentication protocol for SNMP v3
#. Set the SNMP privacy password for SNMP v3
#. Set the SNMP privacy protocol for SNMP v3
#. Set the username for a remote credential (ssh, winrm or esx)
#. Set the authentication password for a remote credential
#. Set the remote authentication port if different than the defaults: 22 for ssh, 5985 for winrm or 5986 for winrm with ssl mode enabled
#. Enable one or more remote inventory mode for ssh or winrm

You can also define a description for this credentials if this can help you to manage them. It is not used by GLPI Agent and it's up to you to use it.

The **name** is free but **mandatory** and will be used as key name to associate it to IP ranges. So choose it carefully to be meaningful for your credentials management.

.. note::

   Passwords are not shown but you have an eye icon on right of the field to click on if you need to check them.

.. cssclass:: no-bottom-margin

When you click on ``Create Credential``, the agent will check few field and will add it to the list unless something is wrong:

.. image:: /_static/images/credentials-added.png

From the credentials list, you'll always have the option to edit or delete a credential.

.. cssclass:: no-bottom-margin

You also can move you mouse pointer other the config column to check few details. Passwords won't be shown:

.. image:: /_static/images/credentials-config.png

Update a credential
"""""""""""""""""""

.. cssclass:: no-bottom-margin

To update a credential, you simply can click on the ``Credential name`` in the **Credentials** list page:

.. image:: /_static/images/credentials-edit.png

You obtain the same form as for `creation <#create-a-credential>`_. And from here, you can:

#. Rename the credential
#. Update any credential setting
#. Click on ``Update`` to save your changes
#. Click on ``Go back to list`` or on ``Credentials`` in the navigation bar to return to the list.

Delete a credential
"""""""""""""""""""

For credential deletion, from the ``Credentials`` list, you have to click on the related checkbox, and click on the ``Delete`` button.

.. warning::

   Deletion will be **forbidden** in the case a credential is still in use. If you really need to remove a credential, first remove it from all associated IP ranges.

.. _toolbox-ip-ranges:

IP Ranges
*********

.. cssclass:: no-bottom-margin

Initially, the IP ranges page will show you it found no IP range:

.. image:: /_static/images/ip_ranges.png

So it essentially gives you access to the ``Add new IP range`` button.

Create an IP range
""""""""""""""""""

.. cssclass:: no-bottom-margin

You can quickly create a new IP range after you have clicked on the ``Add new IP range`` button on the IP range list page:

.. image:: /_static/images/ip_ranges-new.png

You have then a simple form permitting you to first set:

#. the IP range **Name**
#. the **IP range start**
#. the **IP range end**

These fields are all **mandatory** to define an IP range.

The **name** format is free and will be used as a key name to associate it to an inventory job. So choose it carefully to be meaningful for you.

You can also define a description for this IP range if this can help you to manage them. It is not used by GLPI Agent and it's up to you to use it.

.. note::

   If you only need to scan one IP, just use this ip as first and end ip of the range.

   Also you should use an explicit name which will permit you to identify this ip range as targetting only one IP.

You would like also to associate one or more credentials to this new IP range. In **ToolBox**, an IP range without at least one credential will be useless during netscan, so you should at least `have created a first credential <#create-a-credential>`_ before.

When you click on ``Add IP range``, the agent will check few fields and will add it to the list unless something is wrong:

.. image:: /_static/images/ip_ranges-added.png

From the IP Ranges list, you'll always have the option to edit or delete an IP range. But you'll also have a mass action to add or remove one credential to your IP ranges. This is handy when you want to quickly update a lot of IP ranges.

.. cssclass:: no-bottom-margin

You also can move you mouse pointer other the credentials column to check related associated credential details. Passwords won't be shown:

.. image:: /_static/images/ip_ranges-credential-details.png

Update an IP range
""""""""""""""""""

.. cssclass:: no-bottom-margin

To update an IP range, you simply can click on the ``IP range name`` in the **IP Ranges** list page:

.. image:: /_static/images/ip_ranges-edit.png

You obtain the same form as for `ip range creation <#create-an-ip-range>`_. And from here, you can:

#. Rename the IP range
#. Change the start and the end of the IP range
#. Unselect any associated credential
#. Associate another credential, only if another credential is available
#. Click on ``Update`` to save your changes
#. Click on ``Go back to list`` or on ``IP Ranges`` in the navigation bar to return to the list.

Delete an IP range
""""""""""""""""""

For IP range deletion, from the ``IP Ranges`` list, you have to click on the related checkbox, and click on the ``Delete`` button.

.. warning::

   Deletion will be **forbidden** in the case an IP range is still in use. If you really need to remove an IP range, first remove it from all associated netscan inventory tasks.

.. _toolbox-scheduling:

Scheduling
**********

.. cssclass:: no-bottom-margin

Initially, the scheduling page will show you it found no scheduling:

.. image:: /_static/images/scheduling.png

So it essentially gives you access to the ``Add new scheduling`` button.

Create a scheduling
"""""""""""""""""""

.. cssclass:: no-bottom-margin

You can quickly create a new scheduling after you have clicked on the ``Add new scheduling`` button on the Scheduling list page:

.. image:: /_static/images/scheduling-new.png

You have then a simple form permitting you to first set:

#. the scheduling **Name**
#. the **Type**
#. the `delay configuration <#create-a-delay-scheduling>`_ or `timeslot configuration <#create-a-timeslot-scheduling>`_

The name remains **mandatory** to define a scheduling.

The **name** format is free and will be used as a key name to associate it to an inventory job. So choose it carefully to be meaningful for you.

You can also define a description for this scheduling if this can help you to manage them. It is not used by GLPI Agent and it's up to you to use it.

.. cssclass:: no-bottom-margin

When you click on ``Add``, the agent will check few fields and will add it to the list unless something is wrong:

.. image:: /_static/images/scheduling-added.png

From the Scheduling list, you'll always have the option to edit or delete a scheduling. The scheduling details are shown in the configuration column.

Create a delay scheduling
~~~~~~~~~~~~~~~~~~~~~~~~~

.. cssclass:: no-bottom-margin

When you `create a scheduling <#create-a-scheduling>`_, you have to choose the **delay** type.
You can than configure the delay choosing a number for the delay and select a time unit from the given list:

.. image:: /_static/images/scheduling-delay-configuration.png

Create a timeslot scheduling
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. cssclass:: no-bottom-margin

When you `create a scheduling <#create-a-scheduling>`_, you have to choose the **timeslot** type.
You can than configure the timeslot choosing a week day or **all**, a day time start hour and minute, a duration number and a time unit for the duration to choose between **minute** or **hour**:

.. image:: /_static/images/scheduling-timeslot-configuration.png

Update a scheduling
"""""""""""""""""""

.. cssclass:: no-bottom-margin

To update a scheduling, you simply can click on the ``Scheduling name`` in the **Scheduling** list page:

.. image:: /_static/images/scheduling-edit.png

You obtain the same form as for `scheduling creation <#create-a-scheduling>`_. And from here, you can:

#. Rename a scheduling
#. Update the delay duration or the timeslot configuration
#. Click on ``Update`` to save your changes
#. Click on ``Go back to list`` or on ``Scheduling`` in the navigation bar to return to the list.

Delete a scheduling
"""""""""""""""""""

For scheduling deletion, from the ``Scheduling`` list, you have to click on the related checkbox, and click on the ``Delete`` button.

.. warning::

   Deletion will be **forbidden** in the case a scheduling is still in use. If you really need to remove a scheduling, first remove it from all associated inventory tasks.

.. _inventory-tasks:

Inventory tasks
***************

.. cssclass:: no-bottom-margin

Initially, the inventory page will show you it found no inventory task:

.. image:: /_static/images/inventory.png

So it essentially gives you access to the ``Add new inventory task`` button.

Create an inventory task
""""""""""""""""""""""""

.. cssclass:: no-bottom-margin

You can quickly create a new inventory task after you have clicked on the ``Add new inventory task`` button on the Inventory tasks list page:

.. image:: /_static/images/inventory-new.png

You have then a simple form permitting you to first set:

#. the inventory task **Name**
#. the **Type** between **Local inventory** and **Network scan**
#. a target to choose between **Agent folder** and the configured ones via ``server`` or ``local`` parameters
#. a scheduling type
#. a delay or one or more timeslots depending on the choosen scheduling type
#. an optionnal tag to use on computers inventory
#. an IP range to associate if the task type is **Network scan**
#. a threads count if the task type is **Network scan** and to parallelize the task run
#. a connection timeout to use during **Network scan**

The name remains **mandatory** to define an inventory task.

The **name** format is free but choose it carefully to be meaningful for your tasks management.

You can also define a description for this inventory task if this can help you to manage them. It is not used by GLPI Agent and it's up to you to use it.

.. warning::

   ``Local inventory`` task should not be configured via **ToolBox** as this remains the first GLPI Agent role
   when **inventory** task is not disabled in agent configuration.

   This inventory task type should probably only be used for tests or when you need to run it manually from a portable installation, for example using an usb disk on a computer in an isolated networtk.

.. cssclass:: no-bottom-margin

When you click on ``Create inventory task``, the agent will check fields and will add it to the list unless something is wrong:

.. image:: /_static/images/inventory-task-added.png

From the Inventory tasks list, you'll always have the option to edit or delete a task. Some task details are shown in the configuration column.
You can now select the task and ask a run. You can also enable or disable the task. The scheduling will only be used when the task is enabled.

Run an inventory task
"""""""""""""""""""""

An inventory task can be run in 2 cases:

#. manually after it has been selected in the ``Inventory tasks`` list and the ``Run task`` button is clicked
#. after the task has been enabled (select the task and click on ``Enable``) and the agent finds the task scheduling configuration triggers the task

.. image:: /_static/images/inventory-task-run.png

.. cssclass:: no-bottom-margin

After a task has been run, you can see a progression bar. You can click on the eye or report icons to develop the task and access more details or features:

.. image:: /_static/images/inventory-task-run-details.png

Update an inventory task
""""""""""""""""""""""""

To update an inventory task, you simply can click on the ``Task name`` in the **Inventory task** list page.

.. cssclass:: no-bottom-margin

You obtain the same form as for `inventory task creation <#create-a-inventory-task>`_. And from here, you can:

#. Rename the inventory task
#. Change the target
#. Change the used scheduling
#. Change the tag
#. Change the ip range if the task type in **Network scan**
#. Click on ``Update`` to save your changes
#. Click on ``Go back to list`` or on ``Inventory tasks`` in the navigation bar to return to the list.

Delete an inventory task
""""""""""""""""""""""""

For inventory task deletion, from the ``Inventory tasks`` list, you simply have to click on the related checkbox, and click on the ``Delete`` button.

.. note::

   You can also prefer to just disable the task and only delete it after you're sure it won't be used anymore.

Configuration files
*******************

.. cssclass:: no-bottom-margin

There are few files used to configure **ToolBox**:

- ``toolbox-plugin.cfg``: This file permits to setup if and how the GLPI-Agent ToolBox plugin integration
- ``toolbox.yaml``: This YAML file will contains a ``configuration`` section to tune your
  **ToolBox** experience but it will also contain your inventory, credentials, ip ranges & scheduling configurations.
  As such this file **MUST** be secured as much as possible as it will include very sensible data like you defined credentials.

  .. note::

   The ``toolbox.yaml`` file can be backed up when clicking on the ``Backup YAML`` button in the ``ToolBox plugin Configuration`` page.
   This eventually creates a ``backup`` folder at the same level if it doesn't exist.
   And it creates a copy renamed with a timestamp in that ``backup`` sub-folder.

  A **container** can also be setup to support *Custom Fields* but you can also just
  copy the file downloaded from `GLPI Fields plugin <https://github.com/pluginsGLPI/fields>`_
  and select it in the dedicated `Custom fields YAML file` entry in configuration page.
  Be aware, this feature only make sens if you planned to edit locally stored *network inventories*
  before injecting it manually to a GLPI server. This feature has been developed to help people needing
  to scan a private network. It permits to edit manually few custom datas before uploading.

.. rubric:: Footnotes

.. [#f1] on windows the configuration is also a file under the ``etc`` sub-folder of the
   GLPI Agent installation folder.
