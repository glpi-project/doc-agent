Windows installer
-----------------

By default, the installer will bring you to the graphical user interface unless you use the `/i /quiet` options, calling it from command line.

.. prompt:: batch
   :substitutions:

   GLPI-Agent-|version|-x64.msi /quiet SERVER=<URL>

or:

.. prompt:: batch
   :substitutions:

   msiexec /i GLPI-Agent-|version|-x64.msi /quiet SERVER=<URL>

All options can be defined in several places; the last taking precedence on all others:

* default values,
* values from the current GLPI Agent installation,
* values from the command line,
* values from the graphical installer.

.. note::

   When using command line parameters, you should keep in mind:

   * parameters beggining with a slash are indeed ``msiexec.exe`` options,
   * an equal sign is always required for other parameters: ``TAG=prod``,
   * options names are case-sensitive,
   * options values are *not* case-sensitive, unless specified,
   * the equal sign must not be preceded or followed with a space character: ``LOCAL = C:\temp`` is incorrect,
   * if a value contains a space, it must be surrounded with single ``'`` or double quotes ``"``,
   * if you want to set a empty value, put an empty string (``LOCAL=`` or ``LOCAL=""``).

.. attention::

   Don't use **PowerShell** as commandline interpreter: it changes some environment context the installer doesn't handle well.

Command line parameters
-----------------------

``/i``
   Specify this is a normal installation. This is indeed a ``msiexec.exe`` option.

   When used with ``msiexec.exe``, it must be used just before the MSI package path.

``/quiet``
   Silent installation. This is indeed a ``msiexec.exe`` option. (By default: No)

``ADD_FIREWALL_EXCEPTION=1``
   Adds GLPI Agent to the Windows Firewall exception list. (By default: ``0`` for No)

``ADDITIONAL_CONTENT=filename`` (needs MSI installer >= 1.3)
   Specifies an XML file whose content will be automatically merged with output.
   If inventory format is JSON, you can also specify a JSON file from which ``content`` base node will be merged.
   (By default: empty)

``ADDLOCAL=feature[,feature[...]]``
   This parameter permits to select features to install. (By default: "feat_DEPLOY,feat_COLLECT")

   The *feature* can take the following values:

   * ``ALL``: All included tasks are selected for installation
   * ``feat_AGENT``: to restrict to the minimum installation with agent and Inventory task
   * ``feat_NETINV``: to select NetDiscovery and NetInventory tasks for installation
   * ``feat_DEPLOY``: to select Deploy task for installation
   * ``feat_COLLECT``: to select Collect task for installation
   * ``feat_WOL``: to select WakeOnLan task for installation

   The base feature is ``feat_AGENT`` which is always selected and includes Inventory task. By
   default, Deploy and Collect tasks are also selected.

.. _agent-monitor:

``AGENTMONITOR=1`` (needs MSI installer >= v1.5)
   Install Glpi-AgentMonitor (See `GLPI-Agent Monitor project <https://github.com/glpi-project/glpi-agentmonitor>`_).
   Only applicable if GLPI-Agent is installed as a service (i.e. ``EXECMODE=1``).

``BACKEND_COLLECT_TIMEOUT=180``
   Timeout for task ``Inventory`` modules execution. (By default: ``180`` seconds)

``CA_CERT_DIR=pathname``
   Absolute path to the standard certificate directory of certificate
   authorities (CA). (By default: empty)

   The use of this parameter is incompatible with the use of the
   ``CA_CERT_FILE`` parameter. The ``CA_CERT_DIR`` and ``CA_CERT_FILE``
   parameters are mutually exclusive.

   A *standard certificate directory* must contain the certificate files
   corresponding to different certificate authorities in Privacy Enhanced
   Mail (PEM) format, and their names must correspond to the hash value of
   the certificate's *subject* field, with extension ``.0``.

   For example, if you want to include the certificate file
   *FICert\_Class1.crt* in the directory *pathname*, you must calculate the
   hash value of the certificate's *subject* field using, for example,
   OpenSSL

   .. prompt::

      C:\> openssl.exe x509 -in C:\FICert_Class1.crt -subject_hash -noout
      b760f1ce

   and afterwards, move or copy the certificate file to the directory
   *pathname* with the name ``b760f1ce.0``.

   .. prompt:: batch

      move.exe C:\FICert_Class1.crt pathname\b760f1ce.0

``CA_CERT_FILE=filename``
   Full path to the certificates file of certification authorities (CA).
   (By default: empty)

   The use of this parameter is incompatible with the use of the
   ``CA_CERT_DIR`` parameter. The ``CA_CERT_DIR`` and ``CA_CERT_FILE``
   parameters are mutually exclusive.

   *filename* must have extension ``.pem`` (Privacy Enhanced Mail) and can
   contain one or more certificates of certificate authorities. To
   concatenate multiple certificate files into one file you can make use,
   for example, of the command *copy*.

   .. prompt:: batch

      copy.exe FICert_Class1.crt+FICert_Class2.crt FICerts.pem

``DEBUG=level``
   Sets the debug level of the agent. (By default: ``0``)

   *level* can take one of the following values:

   * ``0``: Debug off
   * ``1``: Normal debug
   * ``2``: Full debug

``DELAYTIME=limit``
   Sets an initial delay before first contact with a remote destination
   (see ``SERVER``). This delay is calculated at random between *limit/2*
   and *limit* seconds. (Default: ``3600`` seconds)

   This parameter is ignored for remote destinations after the first contact
   with each one, in favor of the specific server parameter (PROLOG\_FREQ or Contact expiration).

   The ``DELAYTIME`` parameter comes into play only if GLPI Agent
   runs in *server mode* (see ``EXECMODE``).

``EXECMODE=value``
   Sets the agent execution mode. (By default: ``1``)

   *mode* can take one of the following values:

   * ``1`` for ``Service``: The agent runs as a Windows Service (always running)
   * ``2`` for ``Task``: The agent runs as a Windows Task (runs at intervals)
   * ``3`` for ``Manual``: The agent doesn't run automatically (no ``Service``, no ``Task``)

   The mode ``Service`` is known also as *server mode*.

   The mode ``Task`` is only available on Windows XP (or higher) and
   Windows Server 2003 (or higher) operative systems.

``HTML=1``
   Save the inventory as HTML instead of XML or JSON. (By default: ``0`` for No)

   The ``HTML`` parameter comes into play only if you have also indicated a
   value for the ``LOCAL`` parameter.

``HTTPD_IP=ip``
   IP address by which the embedded web server should listen. (By default: ``0.0.0.0``)

``HTTPD_PORT=port``
   IP port by which the embedded web server should listen. (By default: ``62354``)

``HTTPD_TRUST={ip|range|hostname}[,{ip|range|hostname}[...]]``
   Trusted IP addresses that do not require authentication token by the
   integrated web server. (By default: 127.0.0.1/32)

   *ip* is an IP address in dot-decimal notation (ex. "127.0.0.1") or in
   CIDR notation (ex. "127.0.0.1/32")

   *range* is an IP address range in dot-decimal notation (ex. "192.168.0.0
   - 192.168.0.255" or "192.168.0.0 + 255") or in CIDR notation (ex.
   "192.168.0.0/24")

   *hostname* is the name of a host (ex. "itms.acme.org")

   Keep in mind that ``HTTPD_TRUST`` does not have to include the hostname
   part of those URIs that are set up in ``SERVER`` because they are
   tacitly included. The following is an example, both configurations are
   equal:

   .. code::

       ... HTTPD_TRUST="127.0.0.1/32,itms.acme.org" \
           SERVER="http://itms.acme.org/glpi/"

   .. code::

       ... HTTPD_TRUST="127.0.0.1/32" \
           SERVER="http://itms.acme.org/glpi/"

``INSTALLDIR=pathname``
   Sets the installation base directory of the agent. (By default: ``C:\Program Files\GLPI-Agent``)

   *pathname* must be an absolute path.

``JSON=0`` (needs MSI installer >= 1.3)
   Don't save the local inventory as JSON instead of XML. (By default: ``1`` for Yes)

   The ``JSON`` parameter comes into play only if you have also indicated a
   value for the ``LOCAL`` parameter.

``LAZY=1``
   Contact server only if the server expiration delay has been reached. (By default: ``1``)

   This option is only used if you set ``EXECMODE=2`` to use Windows Task scheduling.

``LISTEN=1`` (needs MSI installer >= 1.3)
   Force agent to always listen for requests on httpd interface, even when no target is defined with
   server or local option. (By default: ``0`` for No)

   Very useful in combination with `Inventory Server plugin </plugins/inventory-server-plugin.html>`_.

``LOCAL=pathname``
   Writes the results of tasks execution into the given directory. (By default: empty)

   You must indicate an absolute pathname or an empty string (""). If you
   indicate an empty string, the results of tasks execution will not be
   written locally.

   You can use the ``LOCAL`` and ``SERVER`` options simultaneously.

``LOGFILE=filename``
   Writes log messages into the file *filename*. (By default: ``C:\Program Files\GLPI-Agent\logs\glpi-agent.log``)

   You must indicate a full path in *filename*. The ``LOGFILE`` parameter comes
   into play only if you have also indicated ``file`` as a value of the
   ``LOGGER`` parameter, which is the default.

``LOGFILE_MAXSIZE=size``
   Sets the maximum size of logfile (see ``LOGFILE``) to *size* in MBytes. (By default: 4 MBytes)

``LOGGER=backend[,backend]``
   Sets the logger backends. (By default: ``file``)

   *backend* can take any of the following values:

   * ``file``: Sends the log messages to a file (see ``LOGFILE``)
   * ``stderr``: Sends the log messages to the console

``NO_CATEGORY=category[,category[...]]``
   Do not inventory the indicated categories of elements. (By default: empty)

   *category* can take any value listed by the following command:

   .. prompt:: batch

      "C:\Program Files\GLPI-Agent\glpi-agent" --list-categories

``NO_COMPRESSION=1`` (needs MSI installer >= 1.3)
   Disable compression when exchanging informations with GLPI Server. (By default: ``0``)

``NO_HTTPD=1``
   Disables the embedded web server. (By default: ``0``)

``NO_P2P=1``
   Do not use peer to peer to download files. (By default: ``0``)

``NO_SSL_CHECK=1``
   Do not check server certificate. (By default: ``0``)

``NO_TASK=task[,task[...]]``
   Disables the given tasks. (By default: empty)

   *task* can take any of the following values:

   * ``Deploy``: Task Deploy
   * ``ESX``: Task ESX
   * ``Inventory``: Task Inventory
   * ``NetDiscovery``: Task NetDiscovery
   * ``NetInventory``: Task NetInventory
   * ``WakeOnLan``: Task WakeOnLan

   If you indicate an empty string (""), all tasks will be executed.

``PASSWORD=password``
   Uses *password* as password for server authentication. (By default: empty)

   The ``PASSWORD`` comes into play only if you have also indicated a
   value for the ``SERVER`` parameter.

``PROXY=URI``
   Uses *URI* as HTTP/S proxy server. (By default: empty)

``QUICKINSTALL=1``
   Don't ask for detailed configurations during graphical install. (By default: ``0``)

``REINSTALL=feat_AGENT``
   Use this option only in the case you need to change the agent configuration using the same installer. (Not used by default)

``REMOTE=remote:definition`` (needs MSI installer >= 1.3)
   Specify a remote inventory definition to be used by :doc:`../tasks/remote-inventory` task. (By default: empty)

``REMOTE_WORKERS=max`` (needs MSI installer >= v1.5)
    Set the maximum number of remote inventory to process at the same time. (By default: ``1``)

``RUNNOW=1``
   Launches the agent immediately after its installation. (By default: ``0``)

``SCAN_HOMEDIRS=1``
   Allows the agent to scan home directories for virtual machines. (By default: ``0``)

``SERVER=URI[,URI[...]]``
   Sends results of tasks execution to given servers. (By default: empty)

   If you indicate an empty string (""), the results of tasks execution
   will not be written remotely.

   You can use the ``SERVER`` and ``LOCAL`` parameters simultaneously.

``SSL_CERT_FILE=filename`` (needs MSI installer >= 1.3)
   Specifies the file containing SSL client certificate to use when connecting to
   server target or for WinRM remote inventory.
   (By default: empty)

``SSL_FINGERPRINT=fingerprint`` (needs MSI installer >= 1.3)
   Specifies the fingerprint of the ssl server certificate to trust.

   The fingerprint to use can be retrieved in agent log by temporarily enabling
   `no-ssl-check` option.

``TAG=tag``
   Marks the computer with the tag *tag* . (By default: empty)

``TASKS=task[,task[,...]]``
   Plan tasks in the given order. (By default: empty)

   Not listed tasks won't be planned during a run, unless ``,...`` is specified at the end.

   *task* can take any of the following values:

   * ``Deploy``: Task Deploy
   * ``ESX``: Task ESX
   * ``Inventory``: Task Inventory
   * ``NetDiscovery``: Task NetDiscovery
   * ``NetInventory``: Task NetInventory
   * ``WakeOnLan``: Task WakeOnLan

   If you indicate an empty string (""), all tasks will be executed.
   If you indicate ``,...`` at the end, all not listed tasks will be added in any order.
   You can indicate a task more than one time if this makes sens.

``TASK_DAILY_MODIFIER=modifier``
   Daily task schedule modifier. (By default: ``1`` day)

   *modifier* can take values between 1 and 365, both included.

   The ``TASK_DAILY_MODIFIER`` parameter comes into play only if you have
   also indicated ``daily`` as value of the ``TASK_FREQUENCY`` option.

``TASK_FREQUENCY=frequency``
   Frequency for task schedule. (By default: ``hourly``)

   *frequency* can take any of the following values:

   * ``minute``: At minute intervals (see ``TASK_MINUTE_MODIFIER`` parameter)
   * ``hourly``: At hour intervals (see ``TASK_HOURLY_MODIFIER`` parameter)
   * ``daily``: At day intervals (see ``TASK_DAILY_MODIFIER`` parameter)

``TASK_HOURLY_MODIFIER=modifier``
   Hourly task schedule modifier. (By default: ``1`` hour)

   *modifier* can take values between 1 and 23, both included.

   The ``TASK_HOURLY_MODIFIER`` parameter comes into play only if you have
   also indicated ``hourly`` as value of the ``TASK_FREQUENCY`` parameter.

``TASK_MINUTE_MODIFIER=modifier``
   Minute task schedule modifier. (By default: ``15`` minutes)

   *modifier* can take the any value from 1 to 1439.

   The ``TASK_MINUTE_MODIFIER`` parameter comes into play only if you have
   also indicated ``minute`` as value of the ``TASK_FREQUENCY`` parameter.

``TIMEOUT=180``
   Sets the limit time (in seconds) to connect with the server. (By default: ``180`` seconds)

   The ``TIMEOUT`` parameter comes into play only if you have also indicated
   a value for the ``SERVER`` parameter.

``USER=user``
   Uses *user* as user for server authentication. (By default: empty)

   The ``USER`` parameter comes into play only if you have also indicated a
   value for the ``SERVER`` parameter.

``VARDIR=pathname``
   Sets the vardir base directory of the agent. (By default: ``C:\Program Files\GLPI-Agent\var``)

   This parameter can be used when the agent is installed in a shared storage.

   *pathname* must be an absolute path.
