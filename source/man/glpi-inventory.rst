glpi-inventory
==============

NAME
----

glpi-inventory - Standalone inventory

SYNOPSIS
--------

glpi-inventory [options]

.. code-block:: text

     Options:
       --scan-homedirs                scan use home directories (false)
       --scan-profiles                scan user profiles (false)
       --html                         save the inventory as HTML (false)
       --json                         save the inventory as JSON (false)
       --no-category=CATEGORY         do not list given category items
       --partial=CATEGORY             make a partial inventory of given category
                                        items, this option implies --json
       --credentials                  set credentials to support database inventory
       -t --tag=TAG                   mark the machine with given tag
       --backend-collect-timeout=TIME timeout for inventory modules
                                        execution (30)
       --additional-content=FILE      additional inventory content file
       --verbose                      verbose output (control messages)
       --debug                        debug output (execution traces)
       -h --help                      print this message and exit
       --version                      print the task version and exit

DESCRIPTION
-----------

*glpi-inventory* can be used to run an inventory task without a GLPI
server.
