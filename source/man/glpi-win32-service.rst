glpi-win32-service
==================

.. include:: glpi-win32-service.inc

NAME
----

glpi-win32-service - GLPI perl Agent service for Windows

SYNOPSIS
--------

glpi-win32-service [--register\|--delete\|--help] [options]

.. code-block:: text

     Options are only needed to register or delete the service. They are handy
     while using GLPI perl agent from sources.

     Register options:
       -n --name=NAME                  unique system name for the service
       -d --displayname="Nice Name"    display name of the service
       -l --libdir=PATH                full path to agent perl libraries use it if
                                       not found by the script
       -p --program="path to program"  perl script to start as service

     Delete options:
       -n --name=NAME                  unique system name of the service to delete

     Samples to use from sources base:
       perl bin/glpi-win32-service --help
       perl bin/glpi-win32-service --register
       perl bin/glpi-win32-service --delete
       perl bin/glpi-win32-service --register -n glpi-agent-test -d "[TEST] GLPI Agent Service"
       perl bin/glpi-win32-service --delete -n glpi-agent-test
