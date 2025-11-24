glpi-agent
==========

.. include:: glpi-agent.inc

NAME
----

glpi-agent - GLPI perl agent For Linux/UNIX, Windows and MacOSX

SYNOPSIS
--------

glpi-agent [options] [--server server\|--local path]

.. code-block:: text

     Target definition options:
       -s --server=URI                send tasks result to a server
       -l --local=PATH                write tasks results locally

     Target scheduling options:
       --delaytime=LIMIT              maximum delay before first target,
                                        in seconds (3600). It also defines the
                                        maximum delay on network error. Delay on
                                        network error starts from 60, is doubled at
                                        each new failed attempt until reaching max
       --lazy                         do not contact the target before
                                      next scheduled time
       --set-forcerun                 set persistent state 'forcerun' option so a run
                                      will be started immediately during a start or init

     Task selection options:
       --list-tasks                   list available tasks and exit
       --no-task=TASK[,TASK]...       do not run given task
       --tasks=TASK1[,TASK]...[,...]  run given tasks in given order

     Inventory task specific options:
       --no-category=CATEGORY         do not list given category items
       --list-categories              list supported categories
       --scan-homedirs                scan user home directories (false)
       --scan-profiles                scan user profiles (false)
       --html                         save the inventory as HTML (false)
       --json                         save the inventory as JSON (false)
       -f --force                     always send data to server (false)
       --backend-collect-timeout=TIME timeout for inventory modules execution (180)
       --additional-content=FILE      additional inventory content file
       --assetname-support=1|2        [unix/linux only] set the asset name depending on the given value:
                                       - 1 (the default), the short hostname is used as asset name
                                       - 2, the as-is hostname (can be fqdn) is used as asset name
                                      this feature is not supported on MacOS or Windows
       --partial=CATEGORY             make a partial inventory of given category
                                        items, this option implies --json
       --credentials                  set credentials to support database inventory
       --full-inventory-postpone=NUM  set number of possible full inventory postpone (14)
       --full                         force inventory task to generate a full inventory
       --required-category=CATEGORY   list of category required even when postponing full inventory
       --itemtype=TYPE                set asset type for target supporting genericity like GLPI 11+
                                      Remark: This option is also used by RemoteInventory task

     ESX task specific options:
       --esx-itemtype=TYPE            set ESX asset type for target supporting genericity like GLPI 11+

     RemoteInventory task specific options:
       --remote=REMOTE[,REMOTE]...    specify a list of remotes to process in place
                                      of remotes managed via glpi-remote command
       --remote-workers=COUNT         maximum number of workers for remoteinventory task

     Package deployment task specific options:
       --no-p2p                       do not use peer to peer to download
                                        files (false)

     Network options:
       -P --proxy=PROXY               proxy address
       -u --user=USER                 user name for server authentication
       -p --password=PASSWORD         password for server authentication
       --ca-cert-dir=DIRECTORY        CA certificates directory
       --ca-cert-file=FILE            CA certificates file
       --no-ssl-check                 do not check server SSL certificate
                                        (false)
       --ssl-fingerprint=FINGERPRINT  Trust server certificate if its SSL fingerprint
                                        matches the given one
       -C --no-compression            do not compress communication with server
                                        (false)
       --timeout=TIME                 connection timeout, in seconds (180)

       --ssl-cert-file=FILE           ssl client certificate file
       --ssl-key-file=FILE            ssl client private key file
                                      (asumed included in cert file if missing)

     Web interface options:
       --no-httpd                     disable embedded web server (false)
       --httpd-ip=IP                  network interface to listen to (all)
       --httpd-port=PORT              network port to listen to (62354)
       --httpd-trust=IP               trust requests without authentication
                                        token (false)
       --listen                       enable listener target if no local or
                                      server target is defined

     Server authentication:
       --oauth-client-id=ID           oauth client id to request oauth access token
       --oauth-client-secret=SECRET   oauth client secret to request oauth access token

     Logging options:
       --logger=BACKEND               logger backend (stderr)
       --logfile=FILE                 log file
       --logfile-maxsize=SIZE         maximum size of the log file in MB (0)
       --logfacility=FACILITY         syslog facility (LOG_USER)
       --color                        use color in the console (false)

     Configuration options:
       --config=BACKEND                   configuration backend
       --conf-file=FILE                   configuration file
       --conf-reload-interval=<SECONDS>   number of seconds between two
                                            configuration reloadings

     Execution mode options:
       -w --wait=LIMIT                maximum delay before execution,
                                        in seconds
       -d --daemon                    run the agent as a daemon (false)
       --no-fork                      don't fork in background (false)
       -t --tag=TAG                   add given tag to inventory results
       --debug                        debug mode (false)
       --setup                        print the agent setup directories
                                        and exit
       --vardir=PATH                  use specified path as storage folder for agent
                                        persistent datas

       --glpi-version=<VERSION>       set targeted glpi version to enable supported features
       --version                      print the version and exit
       --no-win32-ole-workaround      [win32 only] disable win32 work-around
                                        used to better handle Win32::OLE apis.
                                        !!! Use it at your own risk as you may
                                        experiment perl crash under win32 !!!

DESCRIPTION
-----------

The *glpi-agent* agent is a generic multi-platform agent. It can perform
a large array of management tasks, such as local inventory, software
deployment or network discovery. It can be used either standalone, or in
combination with a compatible server acting as a centralized control
point.

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

   If *URI* doesn't start with http:// or https://, the agent assume the
   parameter is a hostname and rewrite it as:

   ::

          % --server=http://my-glpi-server/

   In general, GLPI server URL have this format:

   ::

          http://my-glpi-server/

   and FusionInventory for GLPI this one:

   ::

          http://my-glpi-server/plugins/fusioninventory

   Multiple values can be specified, using comma as a separator.

**-l**, **--local**\ =\ *PATH*
   Write the results of tasks execution locally.

   Exact behaviour according to given path:

   -  if *PATH* is a directory, a file will be created therein
   -  if *PATH* is a file, it will be used directly
   -  if *PATH* is '-', STDOUT will be used

   Multiple values can be specified, using comma as a separator.

Target scheduling options
~~~~~~~~~~~~~~~~~~~~~~~~~

**--delaytime**\ =\ *LIMIT*
   Set an initial delay before the first target, whose value is computed
   randomly between LIMIT / 2 and LIMIT seconds. This setting is ignored
   for server targets after the initial contact, in favor of
   server-specified parameter (PROLOG_FREQ).

**--lazy**
   Do not contact the target before next scheduled time.

   This option is only available when the agent is not run as a server.

Task selection options
~~~~~~~~~~~~~~~~~~~~~~

**--list-tasks**
   List all available tasks, tasks planned for execution and exit

**--no-task**\ =\ *TASK*
   Do not run given task.

   Multiple values can be specified, using comma as a separator. See
   option *--list-tasks* for the list of available tasks.

**--tasks**\ =\ *TASK*
   Run given tasks in given order.

   Multiple tasks can be specified, using comma as a separator. A task
   can be specified several times. if '...' is given as last element,
   all other available tasks are executed.

   See option *--list-tasks* for the list of available tasks.

   Examples :

   -  **--tasks=inventory,deploy,inventory**

      First task executed is 'inventory', second task is 'deploy', third
      and last task is 'inventory'.

   -  **--tasks=inventory,deploy,...**

      First executed task is 'inventory', second task is 'deploy' and
      then all other available tasks are executed.

Inventory task specific options
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**--no-category**\ =\ *CATEGORY*
   Do not list given category items in inventory.

   Multiple values can be specified, using comma as a separator. The
   available categories are:

   -  accesslog
   -  antivirus
   -  battery
   -  bios
   -  controller
   -  cpu
   -  database
   -  drive
   -  environment
   -  firewall
   -  hardware
   -  input
   -  licenseinfo
   -  local_group
   -  local_user
   -  lvm
   -  memory
   -  modem
   -  monitor
   -  network
   -  os
   -  port
   -  printer
   -  process
   -  provider
   -  psu
   -  registry
   -  remote_mgmt
   -  rudder
   -  slot
   -  software
   -  sound
   -  storage
   -  usb
   -  user
   -  video
   -  virtualmachine

**--list-categories**
   List all supported categories by scanning all available inventory
   modules

**--credentials**\ =\ *CREDENTIALS*
   Setup credentials for database inventory

   CREDENTIALS should be a list of "key:value" separated by commas like
   in: For example:
   --credentials="type:login_password,login:root,password:\*******\*,use:postgresql,params_id:0"

**--full-inventory-postpone**\ =\ *NUM*
   Set the number of time the agent can decide to generate a partial
   inventory with only changed category before generating a full
   inventory.

**--full**
   Force inventory task to generate a full inventory even if
   **full-inventory-postpone** option is set. Indeed this is equivalent
   to set **--full-inventory-postpone=0**.

**--required-category**\ =\ *CATEGORY*
   Force inventory task to always include given category if
   **full-inventory-postpone** option is set and the current inventory
   task run involves to generate a partial inventory.

   Multiple values can be specified, using comma as a separator. List of
   categories is the same than the one for *--no-category* option, but
   *bios* and *harware* categories are always implied and can be omitted
   as they are still required for normal inventory import.

**--itemtype**\ =\ *TYPE*
   Allow to set JSON inventory itemtype to *TYPE*. This feature requires
   a target supporting genericity, like GLPI 11+.

   When expected asset itemtype in GLPI 11+ is **Server**, *itemtype*
   option value must be set to **Glpi\\CustomAsset\\ServerAsset**.

   **Note:** The suffix **Asset** must always be added at the end of the
   class name to avoid conflicts with PHP reserved keywords.

**--scan-homedirs**
   Allow the agent to scan home directories for virtual machines.

**--scan-profiles**
   Allow the agent to scan user profiles for software.

**--html\|--json**
   Save the inventory as HTML or JSON.

   This is only used for local inventories.

**-f**, **--force**
   Send an inventory to the server, even if this last one doesn't ask
   for it.

**--backend-collect-timeout**\ =\ *TIME*
   Timeout for inventory modules execution.

**--additional-content**\ =\ *FILE*
   Additional inventory content file.

   This file should be an XML file, using same syntax as the one
   produced by the agent.

ESX task specific options
~~~~~~~~~~~~~~~~~~~~~~~~~

**--esx-itemtype**\ =\ *TYPE*
   Allow to set ESX JSON inventory itemtype to *TYPE*. This feature
   requires a target supporting genericity, like GLPI 11+.

   When expected ESX asset itemtype in GLPI 11+ is **Esx**,
   *esx-itemtype* option value must be set to
   **Glpi\\CustomAsset\\EsxAsset**.

Package deployment task specific options
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**--no-p2p**
   Do not use peer to peer to download files.

Server target specific options
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**-P**, **--proxy**\ =\ *PROXY*
   Use *PROXY* as HTTP proxy.

   By default, the agent uses HTTP_PROXY environment variable unless
   option value is defined to **none**.

**-u** *USER*, **--user**\ =\ *USER*
   Use *USER* for server authentication.

**-p**, **--password**\ =\ *PASSWORD*
   Use *PASSWORD* for server authentication.

**--ca-cert-dir**\ =\ *DIRECTORY*
   CA certificates directory.

**--ca-cert-file**\ =\ *FILE*
   CA certificates file.

**--no-ssl-check**
   Do not check server SSL certificate.

**--timeout**\ =\ *TIME*
   Timeout for server connections.

**--ssl-cert-file**\ =\ *FILE*
   SSL client certificate filename.

**--ssl-key-file**\ =\ *FILE*
   SSL client private key filename. If missing, assumed is included in
   cert file

Web interface options
~~~~~~~~~~~~~~~~~~~~~

**--no-httpd**
   Disable the embedded web server.

**--httpd-ip**\ =\ *IP*
   The network interface to use for the embedded web server (all).

**--httpd-port**\ =\ *PORT*
   The network port to use for the embedded web server (62354).

**--httpd-trust**\ =\ *IP*
   Trust requests from given addresses without authentication token
   (false).

   For example: "192.168.0.0/24", "192.168.168.0.5" or an IP range like
   "20.34.101.207 - 201.3.9.99". Hostnames are also accepted. See
   `Net::IP <https://metacpan.org/pod/Net%3A%3AIP>`__ documentation to
   get more example.

   Multiple values can be specified, using comma as a separator.

**--listen**
   This option should be used if no local or server target is defined
   and the agent still needs to answer http requests. **--no-httpd**
   should not be set and **--httpd-trust** should be set to enable
   trusted remote clients.

Server authentication
~~~~~~~~~~~~~~~~~~~~~

**--oauth-client-id**\ =\ *ID*
   The OAuth client id required to authenticate against GLPI >= 11.

**--oauth-client-secret**\ =\ *SECRET*
   The OAuth client secret required to authenticate against GLPI >= 11.

Logging options
~~~~~~~~~~~~~~~

**--logger**\ =\ *BACKEND*
   Logger backend to use.

   Multiple values can be specified, using comma as a separator. The
   available backends are:

   -  stderr: log messages directly in the console.
   -  file: log messages in a file.
   -  syslog: log messages through the local syslog server.

   Multiple values can be specified, using comma as a separator.

**--logfile**\ =\ *FILE*
   Log message in *FILE* (implies File logger backend).

**--logfile-maxsize**\ =\ *SIZE*
   Max logfile size in MB, default is unlimited. When the max size is
   reached, the file is truncated. This is only useful if there is no
   log rotation mechanism on the system.

**--logfacility**\ =\ *FACILITY*
   Syslog facility to use (default LOG_USER).

**--color**
   Display color on the terminal, when the Stderr backend is used.

   This options is ignored on Windows.

Configuration options
~~~~~~~~~~~~~~~~~~~~~

**--config**\ =\ *BACKEND*
   Configuration backend to use.

   The available backends are:

   -  file: read configuration from a file (default anywhere else as
      Windows).
   -  registry: read configuration from the registry (default on
      Windows).
   -  none: don't read any configuration.

**--conf-file**\ =\ *FILE*
   Use *FILE* as configuration file (implies file configuration
   backend).

**--conf-reload-interval**\ =\ *SECONDS*
   SECONDS is the number of seconds between two configuration
   reloadings. Default value is 0, which means that configuration is
   never reloaded. Minimum value is 60. If given value is less than this
   minimum, it is set to this minimum. If given value is less than 0, it
   is set to 0.

Execution mode options
~~~~~~~~~~~~~~~~~~~~~~

**-w** *LIMIT*, **--wait**\ =\ *LIMIT*
   Wait a random delay whose value is computed randomly between 0 and
   LIMIT seconds, before execution. This is useful when execution is
   triggered from some kind of system scheduling on multiple clients, to
   spread the server load.

**-d**, **--daemon**
   Run the agent as a daemon.

**--no-fork**
   Don't fork in background.

   This is only useful when running as a daemon.

**--pidfile**\ [=\ *FILE*]
   Store pid in *FILE* or in default PID file.

   This is only useful when running as a daemon and still not managed
   with a system service manager like systemd.

**--tag**\ =\ *TAG*
   Add the given tag to every inventory results.

**--debug**
   Turn the debug mode on. You can use the parameter up to 3 times in a
   row to increase the verbosity (e.g: **--debug --debug**).

   Level 3 turns on the debug mode of some external libraries like
   `Net::SSLeay <https://metacpan.org/pod/Net%3A%3ASSLeay>`__. These
   messages will only be be printed on STDERR.

**--setup**
   Print the agent setup directories and exit.

**--version**
   Print the version and exit.
