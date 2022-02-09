glpi-netinventory
=================

NAME
----

glpi-netinventory - Standalone network inventory

SYNOPSIS
--------

glpi-netinventory [options] [--host <host>|--file <file>]

.. code-block:: text

     Options:
       --host <HOST>          target host
       --port <PORT[,PORT2]>  SNMP port (161)
       --protocol <PROT[,P2]> SNMP protocol/domain (udp/ipv4)
       --file <FILE>          snmpwalk output file
       --community <STRING>   community string (public)
       --credentials <STRING> SNMP credentials (version:1,community:public)
       --timeout <TIME>       SNMP timeout, in seconds (15)
       --type <TYPE>          force device type
       --threads <COUNT>      number of inventory threads (1)
       --control              output control messages
       --debug                debug output
       -h --help              print this message and exit
       --version              print the task version and exit

DESCRIPTION
-----------

*glpi-netinventory* can be used to run a network inventory task without
a GLPI server.

OPTIONS
-------

**--host** *HOST*
   Run an online inventory against given host. Multiple usage allowed,
   for multiple hosts.

**--port** *PORT[,PORT2]*
   List of ports to try, defaults to: 161

   Set it to 161,16100 to first try on default port and then on 16100.

**--protocol** *PROTOCOL[,PROTOCOL2]*
   List of protocols to try, defaults to: udp/ipv4

   Possible values are: udp/ipv4,udp/ipv6,tcp/ipv4,tcp/ipv6

**--file** *FILE*
   Run an offline inventory against snmpwalk output, stored in given
   file. Multiple usage allowed, for multiple files.

**--communty** *STRING*
   Use given string as SNMP community (assume SNMPv1)

**--credentials** *STRING*
   Use given string as SNMP credentials specification. This
   specification is a comma-separated list of key:value authentication
   parameters, such as:

   -  version:2c,community:public
   -  version:3,username:admin,authprotocol:sha,authpassword:s3cr3t
   -  etc.

**--timeout** *TIME*
   Set SNMP timeout, in seconds.

**--type** *TYPE*
   Force device type, instead of relying on automatic identification.
   Currently allowed types:

   -  COMPUTER
   -  NETWORKING
   -  PRINTER
   -  STORAGE
   -  POWER
   -  PHONE

**--threads** *count*
   Use given number of inventory threads.

**--control**
   Output server-agent control messages, in addition to inventory result
   itself.

**--debug**
   Turn the debug mode on. Multiple usage allowed, for additional
   verbosity.

EXAMPLES
--------

Run an inventory against a network device, using SNMP version 2c
authentication:

.. code-block:: text

       $> glpi-netinventory --host 192.168.0.1 --credentials version:2c,community:public

Run an inventory against a network device, using SNMP version 3
authentication and forcing its type:

.. code-block:: text

       $> glpi-netinventory --host my.device --type NETWORKING \
       --credentials version:3,username:admin,authprotocol:sha,authpassword:s3cr3t
