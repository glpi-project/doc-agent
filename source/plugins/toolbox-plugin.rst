ToolBox interface
=================

.. todo::

   This page describes a new feature which will be released with the next GLPI Agent 1.6 release.

   You still can test the feature and this documentation by installing a `nightly built GLPI-Agent <https://nightly.glpi-project.org/glpi-agent/>`_.

   And of course, you're welcome to :doc:`submit any issue <../bug-reporting>` discovered on nightly builds and related to this new feature.

   .. cssclass:: no-bottom-margin

   Here is a short list of required update to apply on this documentation after the GLPI-Agent 1.6 release:

   #. replace "(available in nightly builds)" notes by "(available since GLPI Agent 1.6)"
   #. update all "will be deprecated" occurence to "deprecated" or "is deprecated" and adapt the sentence context if necessary
   #. remove or update this **Todo** note

**ToolBox** is a simple web interface embedded into GLPI Agent that allows users to configure some features when there is no GLPI server available.

.. cssclass:: no-bottom-margin

For example:

* When you have an isolated network that cannot or should not be connected to a GLPI Server or via GLPI Agent :doc:`proxy-server-plugin` for any reason but you still need to run a network discovery or a network inventory.
* When you need to review and update the inventory with custom fields which can be setup using a YAML file exported from `GLPI Fields plugin <https://github.com/pluginsGLPI/fields>`_.

.. cssclass:: no-bottom-margin

Here are the main features **ToolBox** provides:

* manage inventory task jobs (available in nightly builds)
* manage credentials definitions
* manage ip range definitions
* manage scheduling definitions (available in nightly builds)
* display light inventory results and eventually edit custom fields
* manage remotes definition (will be deprecated in 1.6)
* manage mibsupport rules to tune the results for SNMP network devices

.. note::
   **ToolBox** is not intended to replace a plugin like `GlpiInventory <https://github.com/glpi-project/glpi-inventory-plugin/>`_
   or `FusionInventory for GLPI <https://github.com/fusioninventory/fusioninventory-for-glpi>`_ plugins
   but can be helpful where none of these plugin can or should be used for any reason.

Again **ToolBox** is mainly a GLPI-Agent based tool allowing to run a netscan tasks over a network only using a glpi-agent and a browser.
Netscan task is firstly used to discover and inventory networks devices or printer supporting SNMP,
but now (available in nightly builds), it also supports to discover and inventory computers like ESX, Unix/Linux supporting ssh and windows computers supporting WinRM using :doc:`RemoteInventory task <../tasks/remote-inventory>`.

Run tasks results can be stored in the agent environment and you can browse them on **Results** dedicated pages. But (available in nightly builds) you can also simply and directly send them to a GLPI server, without storing them locally.
You can indeed select as job target any glpi-agent configured target (local or server) or the local glpi-agent installation folder.

.. note::
   Since GLPI Agent 1.5, **ToolBox** also permits to manage :doc:`RemoteInventory task <../tasks/remote-inventory>` by defining and updating remotes.
   It can also be used to expire remotes and require a remoteinventory task run to handle any expired remotes right now.
   The interface is really basic: it doens't show the status of a remote and you'll still have to audit your agent log
   if some remotes are failing to upload an inventory in GLPI.

   For this reason, and as GLPI Agent 1.6 will provide a netscan feature supporting RemoteInventory task, the remotes page will be **deprecated**
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
   By default, anybody can access this feature after is has been enabled. You should first set ``forbid_not_trusted = yes`` in your ``toolbox-plugin.local``
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

Initially, the credentials page will show you an empty list of credentials:

.. image:: /_static/images/credentials.png

It essentially shows you can navigate between **SNMP Credentials v1 and v2c**, **SNMP Credentials v3** and **Remote Credentials** sections.

Create a credential
"""""""""""""""""""

.. cssclass:: no-bottom-margin

You can quickly create a new credentila after you have clicked on the ``Add Credential`` button:

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
#. Set the remote authentication port if different than the defaults: 22 for ssh, 5985 for winrm
#. Enable one or more remote inventory mode for ssh or winrm

You can also define a description for this credentials if this can help you to manage them. It is not used by GLPI Agent and it's up to you to use it.

The **name** is free but **mandatory** and will be used as key name to associate it to IP ranges. So choose it to be meaningful for your credentials management.

.. note::

   Passwords are not shown but you have an eye icon on right of the field to click on if you need to check them.

.. cssclass:: no-bottom-margin

When you click on ``Create Credential``, the agent will check few field and will add it to the list unless something is wrong:

.. image:: /_static/images/credentials-added.png

From the credentials list, you'll always have the option to edit or delete a credential.

Update a credential
"""""""""""""""""""

.. cssclass:: no-bottom-margin

To update a credential, you simply can click on the ``Credential name`` in the **Credentials** list:

.. image:: /_static/images/credentials-edit.png

You obtain the same form as for `creation <#create-a-credential>`_. And from here, you can:

#. Rename a credential
#. Update any credential element
#. Click on ``Update`` to save your change
#. Click on ``Cancel`` or on ``Credentials`` in the navigation bar to return to the list.

.. note::

   If you click on ``Cancel`` after you have first click on ``Update``, this won't revert your saved changes.

Delete a credential
"""""""""""""""""""

For credential deletion, from the ``Credentials`` list, you have to click on the related checkbox, and click on the ``Delete`` button.

.. _toolbox-ip-ranges:

IP Ranges
*********

.. cssclass:: no-bottom-margin

Initially, the IP ranges page will show you an empty list of ranges:

.. image:: /_static/images/ip_ranges.png

.. todo::

   Explain IP ranges management

.. _toolbox-scheduling:

Scheduling
**********

.. cssclass:: no-bottom-margin

Initially, the scheduling page will show you an empty list of scheduling:

.. image:: /_static/images/scheduling.png

.. todo::

   Explain scheduling management

.. _inventory-tasks:

Inventory tasks
***************

.. cssclass:: no-bottom-margin

Initially, the inventory page will show you an empty list of inventory jobs:

.. image:: /_static/images/inventory.png

.. todo::

   Explain inventory tasks management

Configuration files
*******************

.. cssclass:: no-bottom-margin

There are few files used to configure **ToolBox**:

- ``toolbox-plugin.cfg``: This file permits to setup if and how the GLPI-Agent ToolBox plugin integration
- ``toolbox.yaml``: This YAML file will contains a ``configuration`` section to tune your
  **ToolBox** experience but it will also contain your inventory, credentials, ip ranges & scheduling configurations.
  As such this file **MUST** be secured as much as possible as it will include very sensible data like you defined credentials.

  A **container** can also be setup to support *Custom Fields* but you can also just
  copy the file downloaded from `GLPI Fields plugin <https://github.com/pluginsGLPI/fields>`_
  and select it in the dedicated `Custom fields YAML file` entry in configuration page.
  Be aware, this feature only make sens if you planned to edit locally stored *network inventories*
  before injecting it manually to a GLPI server. This feature has been developed to help people needing
  to scan a private network. It permits to edit manually few custom datas before uploading.

  This file can be backed up when clicking on the ``Backup YAML`` button in the ``ToolBox plugin Configuration`` page.
  This eventually creates a ``backup`` folder at the same level if it doesn't exist.
  And it creates a copy renamed with a timestamp in that ``backup`` sub-folder.

.. rubric:: Footnotes

.. [#f1] on windows the configuration is also a file under the ``etc`` sub-folder of the
   GLPI Agent installation folder.
