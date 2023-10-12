ToolBox interface
=================

**ToolBox** is a simple web interface embedded into GLPI Agent that allows users to configure some features when there is no GLPI server available. For example:

- When you have an isolated network that cannot or should not be connected to a GLPI Server or via GLPI Agent :doc:`proxy-server-plugin` for any reason but you still need to run a network discovery or a network inventory.
- When you need to review and update the inventory with custom fields which can be setup using a YAML file exported from `GLPI Fields plugin <https://github.com/pluginsGLPI/fields>`_.

.. note::
   **ToolBox** is not intended to replace a plugin like `GlpiInventory <https://github.com/glpi-project/glpi-inventory-plugin/>`_
   or `FusionInventory for GLPI <https://github.com/fusioninventory/fusioninventory-for-glpi>`_ plugin
   but can be helpful where these can't be used for any reason.

- It allows you to setup SNMP credentials, IP Range and run tasks in order to have access to agentless network devices. In this case, results are stored in the agent environment and you can show them in on dedicated pages to make checks.
- Some MIB-Support rules can also be applied to tune the results as the tasks are run.


.. note::
   Since GLPI Agent 1.5, **ToolBox** also permits to manage :doc:`../tasks/remote-inventory` task by defining and updating remotes.
   It can also be used to expire remotes and require a remoteinventory task start to handle any expired remotes right now.
   The interface is really basic: it doens't show the status of a remote and you'll still have to audit your agent log
   if some remotes are failing to upload an inventory in GLPI.

Setup
*****

By default, **this plugin is disabled**. So the first step needed is to enable it creating a dedicated configuration:

#. Locate the ``toolbox-plugin.cfg`` file under the GLPI agent :ref:`configuration folder <system-location>` [#f1]_,
#. **Make a copy** - avoid renaming it - of this file in the same folder by just changing the file extension from ``.cfg`` to ``.local``.
#. Edit the ``toolbox-plugin.local`` and set ``disabled`` to ``no``

This way, the agent will start to accept toolbox requests on its current port and on ``/toolbox`` as base url.

.. warning::
   As the only current security is a "by trusted IP address" filtering, you should not enable **ToolBox** on an
   unsecure network. Anyway, **since GLPI Agent 1.5**, you can enable :doc:`basic-authentication-server-plugin`
   and :doc:`ssl-server-plugin` to completely secure the **ToolBox** interface.

By default and for security reasons, you only have a very restricted interface this way.

To be able to enable all **ToolBox** features, you also need to edit the ``toolbox.yaml`` file and add the following lines:

::

   configuration:
     updating_support: yes

After you have restarted GLPI-Agent service, you'll see you can edit everything under setup page clicking on the top right gear icon. That is where you can activate additional configurations.

The first thing you'll want to enable is probably all **ToolBox** navigation bar entries.

Configuration
*************

There are few files used to configure **ToolBox**:
 - ``toolbox-plugin.cfg``: This file permits to setup the GLPI-Agent plugin integration
 - ``toolbox.yaml``: This YAML file will contains a ``configuration`` section to tune your
   **ToolBox** experience but it will also be updated with all the datas you'll provide
   to **ToolBox** including sensible datas like SNMP credentials. So keep in mind this
   file **MUST** be secured as much as possible.
   A **container** can also be setup to support *Custom Fields* but you can also just
   copy the file downloaded from `GLPI Fields plugin <https://github.com/pluginsGLPI/fields>`_
   and select it in the dedicated `Custom fields YAML file` entry in configuration page.


.. rubric:: Footnotes

.. [#f1] on windows the configuration is also a file under the ``etc`` sub-folder of the
   GLPI Agent installation folder.
