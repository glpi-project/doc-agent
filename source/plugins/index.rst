HTTP Interface
==============

When run as a daemon or a service, GLPI Agent can be reached on an HTTP interface which, by default, can be reached on port 62354.

The HTTP interface, by default, provides few basic features.

.. image:: /_static/images/localhost_62354.png

It shows agent version, configured targets, next planned run date, and eventually a link to force tasks run if your ip is in the :ref:`trusted list <httpd-trust>`.

The interface provides also an API on ``/status`` page for GLPI server. It returns a short plain text depending on what the agent is currently doing, like:

 - ``status: waiting``
 - ``status: running task inventory``

Security
********

Regarding security, by default, this interface provides a really limited public access as it only permits to see basic informations.

Anyway, when required, the HTTP interface can be disabled by setting :ref:`no-httpd <no-httpd>` configuration.

Listening interface can be changed using :ref:`httpd-ip <httpd-ip>` configuration to restrict it, as by default all network interfaces are use to listen for new connection.
Also the port can be changed to listen on a different port using :ref:`httpd-port <httpd-port>` configuration.

Trusted IP is limited by default and you can trust new ip or iprange configuring :ref:`httpd-trust <httpd-trust>`.

The GLPI server ip is always added to the trusted ip list.

GLPI Agent is provided with few HTTP server plugins which are all disabled by default but can extend the HTTP interface with few nice features.
Regarding security, the `SSL Server plugin <ssl-server-plugin.html>`_ can be used to encrypt HTTP exchange using SSL protocol and
since GLPI Agent v1.5, the `Basic Authentication Server Plugin <basic-authentication-server-plugin.html>`_ can be used in combination
to require authentication (See :ref:`basic-authentication-use-cases`).

Plugins
*******

.. toctree::
   :maxdepth: 3

   basic-authentication-server-plugin
   ssl-server-plugin
   proxy-server-plugin
   inventory-server-plugin
   test-server-plugin
   toolbox-plugin
