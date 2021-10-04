glpi-remoteinventory
====================

.. include:: glpi-remoteinventory.inc

NAME
----

glpi-remoteinventory - A tool to pull inventory from an agent

SYNOPSIS
--------

glpi-remoteinventory [options] <host1> [<host2> ...]

.. code-block:: text

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

DESCRIPTION
-----------

This tool can be used to securely request an inventory from remote
agents not able to contact a server.
