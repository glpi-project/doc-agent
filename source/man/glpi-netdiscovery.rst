glpi-netdiscovery
=================

NAME
----

glpi-netdiscovery - Standalone network discovery

SYNOPSIS
--------

glpi-netdiscovery [options] --first <address> --last <address>

.. code-block:: text

     Options:
       --host <ADDRESS>       Host IP address to scan or IP range first address
       --first <ADDRESS>      IP range first address
       --last <ADDRESS>       IP range last address
       --port <PORT[,PORT2]>  SNMP port (161)
       --protocol <PROT[,P2]> SNMP protocol/domain (udp/ipv4)
       --community <STRING>   SNMP community string (public)
       --credentials <STRING> SNMP credentials (version:1,community:public)
       --timeout <TIME        SNMP timeout, in seconds (1)
       --entity <ENTITY>      GLPI entity
       --threads <COUNT>      number of discovery threads (1)
       --control              output control messages
       --file <FILE>          snmpwalk input file
       -i --inventory         chain with netinventory task for discovered devices
       -s --save <FOLDER>     base folder where to save discovery and inventory xmls
                               - netdiscovery xmls will go in <FOLDER>/netdiscovery
                               - netinventory xmls will go in <FOLDER>/netinventory
       --debug                debug output
       -h --help              print this message and exit
       --version              print the task version and exit

DESCRIPTION
-----------

*glpi-netdiscovery* can be used to run a network discovery task without
a GLPI server.

OPTIONS
-------

**--first|--host** *ADDRESS*
   Set the first IP address of the network range to scan.

**--last** *ADDRESS*
   Set the last IP address of the network range to scan.

   If not set, it is set with the value of the --first or --host option.

**--port** *PORT[,PORT2]*
   List of ports to try, defaults to: 161

   Set it to 161,16100 to first try on default port and then on 16100.

**--protocol** *PROTOCOL[,PROTOCOL2]*
   List of protocols to try, defaults to: udp/ipv4

   Possible values are: udp/ipv4,udp/ipv6,tcp/ipv4,tcp/ipv6

**--file** *FILE*
   Run an offline discovery against snmpwalk output, stored in the given
   file.

   If no host or first ip is provided, ip is set to emulate 1.1.1.1 ip
   scan.

**--community** *STRING*
   Use given string as SNMP community (assume SNMPv1).

**--credentials** *STRING*
   Use given string as SNMP credentials specification. This
   specification is a comma-separated list of key:value authentication
   parameters, such as:

   -  version:2c,community:public
   -  version:3,username:admin,authprotocol:sha,authpassword:s3cr3t
   -  etc.

**--timeout** *TIME*
   Set SNMP timeout, in seconds.

**--entity** *ENTITY*
   Set GLPI entity.

**--threads** *COUNT*
   Use given number of inventory threads.

**--control**
   Output server-agent control messages, in addition to inventory result
   itself.

**--debug**
   Turn the debug mode on. Multiple usage allowed, for additional
   verbosity.

EXAMPLES
--------

Run a discovery against a network range, using SNMP version 1:

.. code-block:: text

       $> glpi-netdiscovery --first 192.168.0.1 --last 192.168.0.254 --community public

Run a discovery against a network range, using multiple SNMP
credentials:

.. code-block:: text

       $> glpi-netdiscovery --first 192.168.0.1 --last 192.168.0.254 \
       --credentials version:2c,community:public \
       --credentials version:3,username:admin,authprotocol:sha,authpassword:s3cr3t

Emulate discovery using a snmpwalk file:

.. code-block:: text

       $> glpi-netdiscovery --file device.walk
