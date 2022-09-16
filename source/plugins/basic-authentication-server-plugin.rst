Basic Authentication Server Plugin
==================================

By default, the agent embedded HTTP interface doesn't support authentication.

The purpose of this plugin is to enable basic authentication on the embedded HTTP interface to secure some exchanges with external clients.

.. note::

   **Basic Authentication Server Plugin** is available since GLPI Agent v1.5

Setup
*****

By default, this plugin is disabled. The first step is to enable it creating a dedicated configuration:

#. Locate the ``basic-authentication-server-plugin.cfg`` file under the GLPI agent :ref:`configuration folder <system-location>` [#f1]_,
#. Make a copy of this file in the same folder by just changing the file extension from ``.cfg`` to ``.local``.
#. Edit the ``basic-authentication-server-plugin.local`` and set ``disabled`` to ``no``

This way, the agent will start to require authentication on few local url like ``http://127.0.0.1:62354/runnow``
and ``http://127.0.0.1:62354/status``.

Configuration
*************

The default configuration is self-explanatory:

::

   # By default, a plugin is always disabled unless "disabled" is set to "no" or "0".
   # You can uncomment the following line or set it in included configuration file
   # at the end of this configuration
   #disabled = no

   # Set url matching regexp to enable basic authentication on, default to any
   # Could be set to /toolbox/.* to enable authentication only on ToolBox plugin
   #url_path_regexp = .*

   # Port on which to request authentication for anonymous requests, default to legacy port
   #port = 62354

   # user and password to be used for authentication, empty by default, must be set to
   # enable the plugin
   #user = [string without a ':' char]
   #password = [string]

   # A realm to be presented to http client, default to "GLPI Agent"
   #realm = GLPI Agent

   # To limit any abuse we expect a maximum of 600 requests by 10 minutes (600 seconds)
   # You can adjust the rate limitation by updating the requests number limit
   # or the period on which apply the requests number limit
   #maxrate        = 600
   #maxrate_period = 600

   # You should create and define you specific parameter in the following
   # included configuration file to override any default.
   # For example just set "disabled = no" in it to enable the plugin
   include "basic-authentication-server-plugin.local"

``disabled``
   Can be set to "no" to enable the plugin. (By default: yes)

``url_path_regexp``
   A regexp defining on which full path must match to support authentication on. (By default: **.***)

   For example, you can enable authentication only on Toolbox by setting it to ``/toolbox.*``.

``port``
   Can be set to the port on which you need to enable authentication. (By default: 62354)

   You can for example keep simple http support on the default port and just enable authentication on the port used by another server plugin.

``user``
   The user name to be used by client to validate authentication. (By default: not defined)

``password``
   The user password to be used by client to validate authentication. (By default: not defined)

``realm``
   A string for basic authentication required by integrated http server. (By default: **Glpi Agent**)

   It defines a site zone where the authentication applies and may appear in the authentication form.

``maxrate`` and ``maxrate_period``
   Limit requests for a given ip to **maxrate** other the **maxrate_period** time (in seconds).
   (By default: **600** requests by **600** seconds for a single ip)

   This 2 parameters could be used to limit abuse if the agent if listening on a public network.

.. _basic-authentication-use-cases:

Basic Authentication use cases
****************************** 

Enabling SSL and basic authentication for ToolBox
"""""""""""""""""""""""""""""""""""""""""""""""""

As :doc:`toolbox-plugin` can show sensible information and can be used to control few tasks, you may want to secure it by:

#. Enable :doc:`toolbox-plugin` on a dedicated port,
#. Enable this basic authentication plugin on that same port for all paths by just setting a port, a user and a password
#. Enable ssl plugin on that same port so every communication with the agent are encrypted, including the basic authentication challenge which can expose user and password to network otherwise.

For example, enable the :doc:`toolbox-plugin` with such ``toolbox-plugin.local`` configuration::

   disabled = no
   port = 8888

Then, enable the basic authentication with such ``basic-authentication-plugin.local`` configuration::

   disabled = no
   port = 8888
   user = admin
   password = mystrongpassword

And finally, enable the :doc:`ssl-server-plugin` with such ``ssl-server-plugin.local`` configuration::

   disabled = no
   ports = 8888
   # openssl req -x509 -newkey rsa:2048 -keyout etc/key.pem -out etc/cert.pem -days 3650 -sha256 -nodes -subj "/CN=A.B.C.D"
   ssl_cert_file = cert.pem
   ssl_key_file  = key.pem

``cert.pem`` and ``key.pm`` can be generated by the following command on linux:

.. prompt:: bash

   openssl req -x509 -newkey rsa:2048 -keyout etc/key.pem -out etc/cert.pem -days 3650 \
      -sha256 -nodes -subj "/CN=A.B.C.D"

Then you'll be able to access your :doc:`toolbox-plugin` with ``https://A.B.C.D/toolbox`` URL. There you would have to trust the server certificate
and then log in with ``admin:mystrongpassword`` as credential.
The ``https://admin:mystrongpassword@A.B.C.D/toolbox`` URL can also be used.

.. rubric:: Footnotes

.. [#f1] On windows, the configuration is also a file and it located under the ``etc`` sub-folder of the
   GLPI Agent installation folder.
