glpi-injector
=============

.. include:: glpi-injector.inc

NAME
----

glpi-injector - A tool to push inventory in an OCS Inventory or
compatible server.

SYNOPSIS
--------

glpi-injector [-h\|--help] [-R\|--recursive] [-r\|--remove]
[-v\|--verbose] [--debug] [--useragent
<user-agent>\|-x\|--xml-ua\|--json-ua] [-C\|--no-compression]
[--no-ssl-check] [--ssl-cert-file <private certificate file>]
[[-P\|--proxy] <proxy url>] [[-f\|--file] <file>|[-d\|--directory]
<directory>\|--stdin] [-u\|--url] <url>

.. code-block:: text

     Options:
       -h --help      this menu
       -d --directory load every inventory files from a directory
       -R --recursive recursively load inventory files from <directory>
       -f --file      load a specific file
       -u --url       server URL
       -r --remove    remove succesfuly injected files
       -v --verbose   verbose mode
       --debug        debug mode to output server answer
       --stdin        read data from STDIN
       --useragent    set used HTTP User-Agent for POST
       -x --xml-ua --json-ua
                      use Client version found in XML or JSON as User-Agent for POST
       --no-ssl-check do not check server SSL certificate
       --ssl-cert-file client certificate file
       -C --no-compression don't compress sent XML inventories
       -P --proxy=PROXY proxy address
       --oauth-client-id
                      oauth client id to request oauth access token
       --oauth-client-secret
                      oauth client secret to request oauth access token

     Examples:
       glpi-injector -v -f /tmp/toto-2010-09-10-11-42-22.json --url https://login:pw@example/
       glpi-injector -v -R -d /srv/ftp/fusion --url https://login:pw@example/

DESCRIPTION
-----------

This tool can be used to test your server, do benchmark or push
inventory from off-line machine.
