SSL Server Plugin
=================

By default, the agent embedded HTTP interface doesn't support message encryption using SSL.

The purpose of this plugin is to enable SSL on the embedded HTTP interface to secure all exchanges with external clients.

Setup
*****

By default, this plugin is disabled. The first step is to enable it creating a dedicated configuration:

#. Locate the ``ssl-server-plugin.cfg`` file under the GLPI agent :ref:`configuration folder <system-location>` [#f1]_,
#. Make a copy of this file in the same folder by just changing the file extension from ``.cfg`` to ``.local``.
#. Edit the ``ssl-server-plugin.local`` and set ``disabled`` to ``no``

This way, the agent will start to only accept client supporting SSL. For instance, if you accessed before the agent interface
on local machine using ``http://127.0.0.1:62354``, you'll now have to use ``https://127.0.0.1:62354``.

Configuration
*************

The default configuration is self-explanatory:

::

   # By default, a plugin is always disabled unless "disabled" is set to "no" or "0".
   # You can uncomment the following line or set it in included configuration file
   # at the end of this configuration
   #disabled = no

   # Comma separated list of ports like in: ports = 62355,62356
   #ports = 0

   # Example command to generate key/certificate files pair
   # openssl req -x509 -newkey rsa:2048 -keyout etc/key.pem -out etc/cert.pem -days 3650 -sha256 -nodes -subj "/CN=127.0.0.1"
   #ssl_cert_file = cert.pem
   #ssl_key_file  = key.pem

   # You should create and define you specific parameter in the following
   # included configuration file to override any default.
   # For example just set "disabled = no" in it to enable the plugin
   include "ssl-server-plugin.local"

``disabled``
   Can be set to "no" to enable the plugin. (By default: yes)

``ports``
   Can be set to a list of ports on which you need to enable SSL support. (By default: 0)

   You can for example keep simple http support on the default port and just enable SSL on the port used by one or more agent server plugins.

``ssl_cert_file``
   The path to the server certificate to use with SSL support. (By default: not defined)

   The path can be relative to the configuration folder or an absolute path.

``ssl_key_file``
   The path to the server private key certificate to use with SSL support. (By default: not defined)

   The path can be relative to the configuration folder or an absolute path. This
   path should be a secured location, not readable by simple local system users.

.. note::

   **ssl_cipher** option is available since GLPI Agent v1.2

``ssl_cipher``
   Set cipher to use for SSL support or set ciphers to disable. (By default: not defined)

   You can for TLS v1.3 support by setting: ``ssl_cipher = TLSv13``

   You disable SSL v3 and TLS v1.1 support by setting: ``ssl_cipher = !SSLv3:!TLSv11``

.. rubric:: Footnotes

.. [#f1] On windows, the configuration is also a file and it located under the ``etc`` sub-folder of the
   GLPI Agent installation folder.
