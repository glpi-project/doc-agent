Test Server Plugin
==================

This plugin has indeed no functional purpose but it can be used as a template if you
need to develop your own GLPI Agent HTTP server plugin.

This plugin when enabled only log the request and just answer to it with a HTTP 200 return code if its URL
matched the ``^/test/([\w\d/-]+)?$`` regular expression.

See the `code for more details <https://github.com/glpi-project/glpi-agent/blob/develop/lib/FusionInventory/Agent/HTTP/Server/Test.pm>`_.

Setup
*****

By default, this plugin is disabled. The first step is to enable it creating a dedicated configuration:

#. Locate the ``server-test-plugin.cfg`` file under the GLPI agent :ref:`configuration folder <system-location>` [#f1]_,
#. Make a copy of this file in the same folder by just changing the file extension from ``.cfg`` to ``.local``.
#. Edit the ``server-test-plugin.local`` and set ``disabled`` to ``no``

Configuration
*************

The default configuration is:

::

   # By default, a plugin is always disabled unless "disabled" is set to "no" or "0".
   # You can uncomment the following line or set it in included configuration file
   # at the end of this configuration
   #disabled = no

   #configtest = test

   #port = 62355

   # You should create and define you specific parameter in the following
   # included configuration file to override any default.
   # For example just set "disabled = no" in it to enable the plugin
   include "server-test-plugin.local"

``disabled``
   Can be set to "no" to enable the plugin. (By default: yes)

``port``
   Can be set to a port on which the agent will listen too. (By default: 0, meaning use agent port)

   You can dedicate a port and even enable the :doc:`ssl-server-plugin` setting
   this port in its ``ports`` list to force using SSL with this Test plugin.

``configtest``
    Just a value that would be logged with the request log line.

.. rubric:: Footnotes

.. [#f1] on windows the configuration is also a file under the ``etc`` sub-folder of the
   GLPI Agent installation folder.
