glpi-remote
===========

.. include:: glpi-remote.inc

NAME
----

glpi-remote - A tool to scan, manage and initialize virtual remote
agents

SYNOPSIS
--------

glpi-remote [options] [--server server\|--local path] [command] [command
options]

.. code-block:: text

     Options:
       -h --help           this menu
       -t --timeout <SECS> requests timeout in seconds (defaults to 10)
       -p --port <LIST>    remote ports list to scan (defaults to '22,5985,5986')
       --ssh               connect using SSH
       --ssl               connect using SSL (winrm or with agent sub-command)
       --no-ssl-check      do not check agent SSL certificate (winrm or agent sub-command)
       --stricthostkeychecking <yes|no|off|accept-new|ask> (defaults to 'accept-new')
                           use given option when checking hostkey during ssh remote add
       --ca-cert-dir <PATH> CA certificates directory
       --ca-cert-file <FILE> CA certificates file (winrm or for agent sub-command)
       --ssl-fingerprint <FINGERPRINT>
                           Trust server certificate if its SSL fingerprint matches the given one
       --ssl-cert-file     Client certificate file (winrm)
       -u --user           authentication user
       -P --password       authentication password
       -X --show-passwords (list command) show password as they are masked by default
       -c --credentials    credentials list for scan
       -v --verbose        verbose mode
       --debug             debug mode
       -C --no-check       don't check given remote is alive when adding
       -i --inventory      don't register remotes, but run inventory on found remotes
       -T --threads <NUM>  number of threads while scanning (defaults to 1)
       -A --add            add scanned remotes to target so they always be inventoried
                           by RemoteInventory task
       -U --useragent      set used HTTP User-Agent for requests
       --vardir <PATH>     use specified path as storage folder for agent persistent datas

     Target definition options:
       -s --server=<URI>   agent will send tasks result to that server
       -l --local=<PATH>   agent will write tasks results locally
       --target=<TARGETID> use target identified by its id (see list targets command)

     Remote GLPI agent having inventory server plugin enabled options:
       -b --baseurl <PATH> remote base url if not /inventory
       -K --token <TOKEN>  token as shared secret
       -I --id <ID>        request id to identify requests in agent log
       --no-compression    ask to not compress sent XML inventories

     Sub-commands
       list [targets]      list known remotes or targets
       add <url>+          add remote with given URL list
       del[ete] <index|deviceid>+
                           delete remote with given list index or given deviceid or
                           current known one when alone or all remotes while using
                           __ALL__ as id
       scan <first> [last] [TODO] scan given ip range for remote access or just <first> and
                           register it/them as remote agent
       agent [hosts]       remotely claim an inventory to given remote hosts with a
                           GLPI agent having inventory server plugin enabled
                           (see https://glpi-agent.rtfd.io/inventory-server-plugin.html)

     Supported environment variables:
       USERNAME
       PASSWORD
       PORT
       CA_CERT_PATH
       CA_CERT_FILE
       SSL_CERT_FILE
       CREDENTIALS

     Examples:
       glpi-remote list
       glpi-remote list targets
       glpi-remote add ssh://admin:pass@192.168.43.237
       glpi-remote add ssh://admin:pass@192.168.43.237 --stricthostkeychecking=no
       glpi-remote add ssh://admin:pass@192.168.43.238 --no-check
       glpi-remote add winrm://admin:pass@192.168.48.250 --no-check --target server0
       glpi-remote delete 1
       glpi-remote scan 192.168.43.1 192.168.43.254
       glpi-remote scan 10.0.0.1 10.0.10.254 --inventory -s https://myglpi/
       glpi-remote scan 10.0.0.1 10.0.10.254 --inventory -l /var/tmp/remotes
       glpi-remote scan --inventory
       glpi-remote scan 192.168.48.99 | glpi-injector --url https://myglpi/

     Examples for agent command:
       glpi-remote -T strong-shared-secret agent 192.168.43.236
       glpi-remote -v -T strong-shared-secret agent 192.168.43.237 | \
           glpi-injector -url https://myglpi/
       glpi-remote -T strong-shared-secret -d /var/remote agent 192.168.43.236 192.168.43.237

DESCRIPTION
-----------

The *glpi-remote* tool is used to manage virtual agents known locally by
*glpi-agent*. A virtual agent is used to make remote inventories and is
essentially defined by a remote access. A remote access can be defined
by ssh authorization for unix/linux platforms or WinRM authorizations
for a WinRM enabled platform like win32.

OPTIONS
-------

Most of the options are available in a *short* form and a *long* form.
For example, the two lines below are all equivalent:

.. code-block:: text

       % glpi-agent -s localhost
       % glpi-agent --server localhost

Target definition options
~~~~~~~~~~~~~~~~~~~~~~~~~

**-s**, **--server**\ =\ *URI*
   Send the results of tasks execution to given server.

   Multiple values can be specified, using comma as a separator.

**-l**, **--local**\ =\ *PATH*
   Write the results of tasks execution locally.

**--target**\ =\ *TARGETID*
   Use the given TARGETID to look for the expected target for result
   submission.

   For example, **server0** is the first server target setup in agent
   configuration.

**Remark:**

-  target option is generaly mandatory while adding remote or scanning
   for remotes
-  if one server and only one is still setup in the agent it will be
   selected as default target
-  when scanning and making inventory, uses any target option or each
   inventory will be sent to standard output

General options
~~~~~~~~~~~~~~~

**-t**, **--timeout**\ =\ *SECS*
   Set the timeout for network requests (defaults to 10 seconds).

**-p**, **--port**\ =\ *LIST*
   A list of ports used when making a scan and to discover remote
   computers. The defaults is to scan the standard ssh port and winrm
   ports: *22,5985,5986*.

**--ssh**
   Use ssh protocol for connection.

**--ssl**
   Use SSL protocol for connecting with WinRM protocol or to a remote
   agent with inventory server plugin enabled.

**--ca-cert-dir**\ =\ *DIRECTORY*
   CA certificates directory.

**--ca-cert-file**\ =\ *FILE*
   CA certificates file.

**--ssl-cert-file**\ =\ *FILE*
   SSL certificate file for authentication

**--no-ssl-check**
   Do not check server SSL certificate.

**-u** *USER*, **--user**\ =\ *USER*
   Use *USER* for remote authentication.

**-P**, **--password**\ =\ *PASSWORD*
   Use *PASSWORD* for remote authentication.

**-X**, **show-passwords**
   By default, **list** sub-command won't show remotes passwords. This
   option asks to unmask them during remotes listing.

**-c**, **--credentials**\ =\ *LIST*
   List of credentials to try during a scan.

**-v**, **--verbose**
   Enable verbose mode.

**--debug**
   Turn the debug mode on. You can use the parameter up to 2 times in a
   row to increase the verbosity (e.g: **--debug --debug**).

**-C**, **--no-check**
   Don't check remote is alive while adding it.

**-i**, **--inventory**
   Don't register remotes as they are discovered but just run the
   inventory task on them.

**-T**, **--threads**\ =\ *NUM*
   Setup number of threads while doing a scan. By default, the agent
   only uses one thread.

**-A**, **--add**
   Add discovered remotes to local remotes list.

**-U**, **--useragent**\ =\ *USER-AGENT*
   Define HTTP user agent for request (mostly if required for winrm).

*agent* sub-command options
~~~~~~~~~~~~~~~~~~~~~~~~~~~

**-b**, **--baseurl**\ =\ *PATH*
   Remote base url if the default */inventory* has been changed in the
   remote plugin configuration.

**-K**, **--token**\ =\ *TOKEN*
   Shared secret required to request an inventory to the remote plugin.

**-I**, <--id>=\ *ID*
   Request-ID to identify the request in the agent log.

**--no-compression**
   Ask to skip requested inventory compression.

Sub-commands
~~~~~~~~~~~~

-  **list** [**targets**]

   list known remotes or list targets

-  **add** *url*\ +

   add remote with given URL list

-  **del[ete]** *index|deviceid*\ +

   Delete remote with given:

   -  list index
   -  given deviceid
   -  current and only one known when no index is given
   -  all known remotes while using the **\__ALL\_\_** magic word as
      index

-  **scan** *first* [*last*]

   **TODO:** *This sub-command is still not implemented*.

   Scan given ip range for remote access or just *first* and register
   it/them as remote agent

-  **agent** [*hosts*]

   Remotely claim an inventory to given remote hosts with a GLPI agent
   having inventory server plugin enabled.

   See online documentation for details:
   https://glpi-agent.rtfd.io/inventory-server-plugin.html

Environment variables
~~~~~~~~~~~~~~~~~~~~~

For security reasons, you can set few environment variables to store
sensible datas.

-  **USERNAME** to setup connection user
-  **PASSWORD** to setup connection password
-  **PORT** to setup connection port
-  **CA_CERT_PATH**
-  **CA_CERT_FILE** to setup the SSL CA certificate file
-  **SSL_CERT_FILE** to setup the SSL client certificate file
-  **CREDENTIALS** to setup a list of credentials
