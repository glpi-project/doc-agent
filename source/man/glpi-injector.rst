glpi-injector
=============

NAME
----

glpi-injector - A tool to push inventory in an OCS Inventory or
compatible server.

SYNOPSIS
--------

glpi-injector [options] [--file <file>|--directory
<directory>|--stdin|--useragent <user-agent>]

.. code-block:: text

     Options:
       -h --help      this menu
       -d --directory load every .ocs files from a directory
       -R --recursive recursively load .ocs files from <directory>
       -f --file      load a specific file
       -u --url       server URL
       -r --remove    remove succesfuly injected files
       -v --verbose   verbose mode
       --debug        debug mode to output server answer
       --stdin        read data from STDIN
       --useragent    set used HTTP User-Agent for POST
       -x --xml-ua    use Client version found in XML as User-Agent for POST
       -x --json-ua   use Client version found in JSON as User-Agent for POST
       --no-ssl-check do not check server SSL certificate
       -C --no-compression don't compress sent XML inventories

     Examples:
       glpi-injector -v -f /tmp/toto-2010-09-10-11-42-22.ocs --url https://login:pw@example/plugins/fusioninventory/
       glpi-injector -v -R -d /srv/ftp/fusion --url https://login:pw@example/plugins/fusioninventory/

DESCRIPTION
-----------

This tool can be used to test your server, do benchmark or push
inventory from off-line machine.
