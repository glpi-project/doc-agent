glpi-esx
========

.. include:: glpi-esx.inc

NAME
----

glpi-esx - vCenter/ESX/ESXi remote inventory from command line

SYNOPSIS
--------

glpi-esx --host <host> --user <user> --password <password> --path
<directory or file>

.. code-block:: text

     Options:
       --help                 this menu
       --debug                debug mode (false)
       --host hostname        ESX server hostname
       --user username        user name
       --password xxxx        user password
       --path path            output directory or file
       -t --timeout sec       connection attempt timeout in seconds (defaults to 180)
       --stdout               dump inventory on stdout (enabled by default if no path is set)
       --tag tag              tag for the inventoried machine
       --json                 use json as format for generated inventories

     Advanced options:
       --dump                 also dump esx host full info datas in a *-hostfullinfo.dump file
       --dumpfile file        generate one inventory from a *-hostfullinfo.dump file

EXAMPLES
--------

.. code-block:: text

       % glpi-esx --host myesx --user foo --password bar --path /tmp --json

You can import the .json file in your inventory server with the
glpi-injector tool.

.. code-block:: text

       % glpi-injector -v --file /tmp/*.json -u https://example/

DESCRIPTION
-----------

*glpi-esx* creates inventory of remote ESX/ESXi and vCenter VMware. It
uses the SOAP interface of the remote server.

Supported systems:

*ESX and ESXi 3.5*

*ESX and ESXi 4.1*

*ESXi 5.0*

*vCenter 4.1*

*vCenter 5.0*

Active Directory users, please note the AD authentication doesn't work.
You must create a account on the VMware server.

LIMITATION
----------

So far, ESX serial number are not collected.

SECURITY
--------

The SSL hostname check of the server is disabled.
