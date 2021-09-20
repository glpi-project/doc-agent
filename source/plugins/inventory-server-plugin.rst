Inventory Server Plugin
=======================

Context
*******

When run as a daemon or a service, by default, GLPI Agent can be reached on an HTTP interface.
By default, GLPI Agent listens on port 62354, but this can be disabled by setting :ref:`no-httpd configuration <no-httpd>`
or changed to listen on a different port using :ref:`httpd-port configuration <httpd-port>`.

Purpose
*******

This plugin purpose is to permit requesting an inventory from a trusted remote computer knowing a shared secret.
This is handy in the case the agent has no way to contact the GLPI server by itself.

Setup
*****

By default, this plugin is disabled. The first step is to enable it creating a dedicated configuration:

#. Locate the ``inventory-server-plugin.cfg`` file under the GLPI agent :ref:`configuration folder <system-location>` [#f1]_,
#. Make a copy of this file in the same folder by just changing the file extension from ``.cfg`` to ``.local``.
#. Edit the ``inventory-server-plugin.local`` and set ``disabled`` to ``no``
#. Also set a private token setting the ``token`` parameter to any strong secret

This way, the agent will start to accept inventory requets from a computer knowing the shared secret.
To do so, just use the :ref:`glpi-remoteinventory <inventory-request>` companion script.

.. hint::

   You can also enable the :doc:`ssl-server-plugin` to also encrypt the communication.

.. note::

   This HTTP server plugin feature as nothing to do with the glpi-agent remote inventory feature as here, you still need to install a GLPI Agent on the targeted systems.
   With the glpi-agent remote inventory feature, you don't need any agent on the targeted systems.

Configuration
*************

The default configuration is self-explanatory:

::

   # Set this to no or 0 to enable Inventory HTTP::Daemon Server plugin and
   # permit remote inventory request for this agent
   disabled = yes

   # Set base url matching for API
   #url_path = /inventory

   # Port on which to listen for inventory requests, default to legacy port
   #port = 62354

   # token as private secret used to verify authorization token, not defined by
   # default, but mandatory to access API
   #token = [secret-string]

   # A timeout for session to no more trust a client payload
   #session_timeout = 60

   # Set this to 'yes' if XML compression is not required
   #no_compress = no

   # To limit any abuse we expect a maximum of 50 requests by hour (3600 seconds)
   # You can adjust the rate limitation by updating the requests number limit
   # or the period on which apply the requests number limit
   #maxrate        = 30
   #maxrate_period = 3600

   # You should create and define you specific parameter in the following
   # included configuration file to override any default.
   # For example just set "disabled = no" in it to enable the plugin
   include "inventory-server-plugin.local"

``disabled``
   Can be set to "no" to enable the plugin. (By default: yes)

``url_path``
   The path to the server certificate to use with SSL support. (By default: **/inventory**)

   The path can be relative to the configuration folder or an absolute path.

``port``
   Can be set to a port on which the agent will listen too. (By default: **0**, meaning use agent port)

   You can dedicate a port for the inventory usage. You can even enable the :doc:`ssl-server-plugin`, and
   set the port in its ``ports`` list to force using SSL with the inventory plugin.

``token``
   **MUST** be set to a strong secret or no inventory will be generated. (By default: not defined)

``session_timeout``
   The session timeout is a time in seconds and defines the maximum time the agent will
   wait for the remote client to authentify itself with the shared secret. (By default: **60**)

``no_compress``
   Can be set to **yes** to avoid inventory compression when sent back. (By default: **no**)

``maxrate`` and ``maxrate_period``
   Limit requests for a given ip to **maxrate** other the **maxrate_period** time (in seconds).
   (By default: **30** requests by **3600** seconds for a single ip)

   This 2 parameters could be used to limit even more any brute force attack attempt.

.. _inventory-request:

Inventory request
*****************

Inventory request should be done by the ``glpi-remoteinventory`` companion script.

The ``--help`` option includes some examples:

.. prompt:: bash

   bin/glpi-remoteinventory --help

::

   Usage:
      glpi-remoteinventory [options] <host1> [<host2> ...]

         Options:
          -h --help      this menu
          -d --directory store xml files to the given directory
          -t --timeout   requests timeout and even inventory get timeout
          -b --baseurl   remote base url if not /inventory
          -p --port      remote port (62354 by default)
          -T --token     token as shared secret
          -i --id        request id to identify requests in agent log
          -s --ssl       connect using SSL
          --no-ssl-check do not check agent SSL certificate
          --ca-cert-file CA certificates file

          -C --no-compression
                         ask to not compress sent XML inventories

          -v --verbose   verbose mode
          --debug        debug mode
          -u --useragent set used HTTP User-Agent for requests

         Examples:
          glpi-remoteinventory -T strong-shared-secret 192.168.43.236
          glpi-remoteinventory -v -T strong-shared-secret 192.168.43.237 | \
              glpi-injector -url https://login:pw@server/plugins/fusioninventory/
          glpi-remoteinventory -T strong-shared-secret -d /tmp 192.168.43.236 192.168.43.237

Use cases
*********

DMZ server inventory
""""""""""""""""""""

In the case you have a server in DMZ which cannot access the GLPI server, but the GLPI server is authorized to reach it. You still can install an agent on it.

Then first, enable the plugin with such ``inventory-server-plugin.local`` configuration::

   disabled = no
   token = 5c9898f9-e619-4bdb-8e29-6a20766ab760

In the agent conf, don't set ``server`` nor ``local`` but set ``listen`` to ``yes`` and set ``httpd-trust`` with the GLPI server one. For example create the ``/etc/glpi-agent/conf.d/local.cfg`` file with::

   listen = yes
   httpd-trust = <glpi-server-ip>

On the GLPI server, create a script you would want to put in ``/etc/cron.daily``::

   #!/bin/bash
   sleep $((RANDOM/100))
   glpi-remoteinventory -T 5c9898f9-e619-4bdb-8e29-6a20766ab760 <dmz-server-ip> | \
      glpi-injector -url http://127.0.0.1/front/inventory.php >/var/tmp/server-inventory.log 2>&1

Adapt this shell script to your needs.

Internet server
"""""""""""""""

In the case you have an internet server hosted anywhere and you want to inventory it in your GLPI being in your intranet.

Make sure server and intranet firewalls will permits communications between them, the GLPI server being the HTTP client and let's say via the ``54443`` port.

Then first, after installed the agent on the internet server, enable the plugin with such ``inventory-server-plugin.local`` configuration::

   disabled = no
   token = 2b0a48a2-6eb1-4e8f-bf8c-41f461b58ef1
   base = /2cd3a12ac1c4
   port = 54443

Also enable the :doc:`ssl-server-plugin` with such ``ssl-server-plugin.local`` configuration::

   disabled = no
   ports = 54443

In the agent conf, don't set ``server`` nor ``local`` but set ``listen`` to ``yes`` and set ``httpd-trust`` with your intranet public one. For example create the ``/etc/glpi-agent/conf.d/glpi.cfg`` file with::

   listen = yes
   httpd-trust = <intranet-public-ip>

On the GLPI server, create a script you would want to put in ``/etc/cron.daily``::

   #!/bin/bash
   sleep $((RANDOM/100))
   glpi-remoteinventory -T 2b0a48a2-6eb1-4e8f-bf8c-41f461b58ef1 <internet-server-ip> -p 54443 --ssl --no-ssl-check -b /2cd3a12ac1c4 | \
      glpi-injector -url http://127.0.0.1/front/inventory.php >/var/tmp/internet-server-inventory.log 2>&1

Adapt this shell script to your needs.

.. rubric:: Footnotes

.. [#f1] on windows the configuration is also a file under the ``etc`` sub-folder of the
   GLPI Agent installation folder.
