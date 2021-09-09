:orphan:

Windows command line installation manual
========================================

Two types of installations are possible:

* **from scratch**, which allows a new brand installation, based on default options (see below),
* **from-current-config** which will use your current installation options.

In all cases, any previous installation of a GLPI Agent will be removed before the new installation is done.

Per default, the installer will bring you to the graphical user interface unless you use the `/S` flag calling it from command line.

.. code-block:: doscon

   C:\> glpi-agent_windows-<platform>_<version>.exe /S

All options can be defined in several places; the last takes precedence on all others:

* default values,
* values from the current GLPI Agent installation (``from-current-config`` installation type only),
* values from the command line,
* values from the graphical installer.

.. note::

   When using command line options, you should keep in mind:

   * there are two types of options; those that act as a switch (``/option``), and those that have a value (``/option=value``),
   * options names are case-sensitive,
   * options values are *not* case-sensitive, unless specified,
   * for valued options:

      * the equal sign must not be preceded or followed with a space character, (``/local = c:\\temp`` is incorrect),
      * if the value contains a space or the slash (``/``) character, it must be surrounded with single or double quotes (either ``'`` or ``"``)
      * if you want to set a empty value, put an empty string (``/local=''``).

Command line options
--------------------

``/acceptlicense``
   You accept and acknowledge that you have read, and understood, the terms
   and conditions of GLPI Agent license. (By default: No)

   You must use this option if you perform the installation in silent mode
   (see ``/S``).

   If you indicate this option on the command line, but not the ``/S``
   option, the *visual mode* installation will omit any question about the
   license.

``/add-firewall-exception``
   Adds GLPI Agent to the Windows Firewall exception list. (By
   default: No)

``/backend-collect-timeout=timeout``
   Timeout for task ``Inventory`` modules execution. (By default: 180
   seconds)

``/ca-cert-dir=pathname``
   Absolute path to the standard certificate directory of certificate
   authorities (CA). (By default: "")

   The use of this option is incompatible with the use of the
   ``/ca-cert-file`` option. The ``/ca-cert-dir`` and ``/ca-cert-file``
   options are mutually exclusive.

   A *standard certificate directory* must contain the certificate files
   corresponding to different certificate authorities in Privacy Enhanced
   Mail (PEM) format, and their names must correspond to the hash value of
   the certificate's *subject* field, with extension ``.0``.

   For example, if you want to include the certificate file
   *FICert\_Class1.crt* in the directory *pathname*, you must calculate the
   hash value of the certificate's *subject* field using, for example,
   OpenSSL

   .. code-block:: doscon

      C:\OpenSSL> openssl.exe x509 -in C:\FICert_Class1.crt -subject_hash -noout b760f1ce

   and afterwards, move or copy the certificate file to the directory
   *pathname* with the name ``b760f1ce.0``.

   .. code-block:: doscon

      C:\OpenSSL> move.exe C:\FICert_Class1.crt pathname\b760f1ce.0

``/ca-cert-file=filename``
   Full path to the certificates file of certification authorities (CA).
   (By default: "")

   The use of this option is incompatible with the use of the
   ``/ca-cert-dir`` option. The ``/ca-cert-dir`` and ``/ca-cert-file``
   options are mutually exclusive.

   *filename* must have extension ``.pem`` (Privacy Enhanced Mail) and can
   contain one or more certificates of certificate authorities. To
   concatenate multiple certificate files into one file you can make use,
   for example, of the command *copy*.

   .. code-block:: doscon

      C:\> copy.exe FICert_Class1.crt+FICert_Class2.crt FICerts.pem

``/ca-cert-uri=URI``
   *URI* from where to obtain the file or files of certificate of
   authorities (CA). (By default: "")

   The use of this option requires the joint use of the ``/ca-cert-dir`` or
   ``/ca-cert-file`` options, but not both.

``/debug=level``
   Sets the debug level of the agent. (By default: 0)

   *level* can take one of the following values:

   * ``0``: Debug off
   * ``1``: Normal debug
   * ``2``: Full debug

``/delaytime=limit``
   Sets an initial delay before first contact with a remote destination
   (see ``/server``). This delay is calculated at random between *limit/2*
   and *limit* seconds. (Default: 3600 seconds)

   This option is ignored for remote destinations after the first contact
   with each one, in favor of the specific server parameter (PROLOG\_FREQ).

   The ``/delaytime`` option comes into play only if GLPI Agent
   runs in *server mode* (see ``/execmode``).

``/dumphelp``

   Creates a RTF file with this help, and aborts the installation.

``/execmode=mode``
   Sets the agent execution mode. (By default: ``Current``)

   *mode* can take one of the following values:

   * ``Service``: The agent runs as a Windows Service (always running)
   * ``Task``: The agent runs as a Windows Task (runs at intervals)
   * ``Manual``: The agent doesn't run automatically (no ``Service``, no ``Task``)
   * ``Current``: The agent runs in the same way that the agent already installed runs

   The mode ``Service`` is known also as *server mode*.

   The mode ``Task`` is only available on Windows XP (or higher) and
   Windows Server 2003 (or higher) operative systems.

   In the case of an installation ``from-scratch`` (see ``/installtype``),
   the ``Current`` mode is a synonym of ``Service``.

``/help``
   This help. If the ``/help`` option is present, shows the help and aborts
   the installation.

``/html``
   Save the inventory as HTML instead of XML. (By default: No)

   The ``/html`` option comes into play only if you have also indicated a
   value for the ``/local`` option.

``/httpd``
   This option is the opposite of ``/no-httpd``. See ``/no-httpd`` for more
   information.

``/httpd-ip=ip``
   IP address by which the embedded web server should listen. (By default: 0.0.0.0)

``/httpd-port=port``
   IP port by which the embedded web server should listen. (By default: 62354)

``/httpd-trust={ip|range|hostname}[,{ip|range|hostname}[...]]``
   Trusted IP addresses that do not require authentication token by the
   integrated web server. (By default: 127.0.0.1/32)

   *ip* is an IP address in dot-decimal notation (ex. "127.0.0.1") or in
   CIDR notation (ex. "127.0.0.1/32")

   *range* is an IP address range in dot-decimal notation (ex. "192.168.0.0
   - 192.168.0.255" or "192.168.0.0 + 255") or in CIDR notation (ex.
   "192.168.0.0/24")

   *hostname* is the name of a host (ex. "itms.acme.org")

   Keep in mind that ``/httpd-trust`` does not have to include the hostname
   part of those URIs that are set up in ``/server`` because they are
   tacitly included. The following is an example; both configurations are
   equal.

   .. code-block:: doscon

       /httpd-trust="127.0.0.1/32,itms.acme.org"
       /server="http://itms.acme.org/glpi/front/inventory.php"

   .. code-block:: doscon

       /httpd-trust="127.0.0.1/32"
       /server="http://itms.acme.org/glpi/front/inventory.php"

``/installdir=pathname``
   Sets the installation base directory of the agent. (By default: ``C:\Program Files\GLPI-Agent``)

   *pathname* must be an absolute path.

``/installtasks``={task[,task[...]]|macro}``
   Selects the tasks to install. (By default: ``Default``)

   *task* can be take any of the following values:

   * ``Deploy``: Task Deploy
   * ``ESX``: Task ESX
   * ``Inventory``: Task Inventory
   * ``NetDiscovery``: Task NetDiscovery
   * ``NetInventory``: Task NetInventory
   * ``WakeOnLan``: Task WakeOnLan

   There are three macros defined to simplify the mission, are the
   following:

   * ``Minimal``: ``Inventory``
   * ``Default``: ``Inventory``
   * ``Full``: ``Deploy``, ``ESX``, ``Inventory``, ``NetDiscovery``, ``NetInventory``, ``WakeOnLan``

   It should be noted that the ``Inventory`` task will be always installed
   and that the ``NetDiscovery`` and ``NetInventory`` tasks are
   inter-dependent. Nowadays ``Minimal`` and ``Default`` are the same
   configuration.

``/installtype={from-scratch|from-current-config}``
   Selects between an installation from the beginning (``from-scratch``)
   or, whether the system has a previously installed agent, an installation
   based on the current configuration (``from-current-config``). (By
   default: ``from-current-config``)

   The installer automatically switches from ``from-current-config`` to
   ``from-scratch`` whether it's not able to detect a GLPI Agent
   previously installed on the system. This behaviour makes unnecessary to
   have to indicate ``/installtype=from-scratch`` to perform an
   installation on those systems in which it doesn't
   exist previously and, at the same time, facilitates the update of
   GLPi Agent on those systems in which it exists.

``/local=pathname``
   Writes the results of tasks execution into the given directory. (By
   default: "")

   You must indicate an absolute pathname or an empty string (""). If you
   indicate an empty string, the results of tasks execution will not be
   written locally.

   You can use the ``/local`` and ``/server`` options simultaneously.

``/logfile=filename``
   Writes log messages into the file *filename*. (By default: ``C:\\Program Files\\GLPI-Agent\\glpi-agent.log``)

   You must indicate a full path in *filename*. The ``/local`` option comes
   into play only if you have also indicated ``File`` as a value of the
   ``/logger`` option.

``/logfile-maxsize=size``
   Sets the maximum size of logfile (see ``/logfile``) to *size* . (By
   default: 16 MBytes)

``/logger=backend[,backend]``
   Sets the logger backends. (By default: File)

   *backend* can take any of the following values:

   * ``File``: Sends the log messages to a file (see ``/logfile``)
   * ``Stderr``: Sends the log messages to the console

``/no-category=category[,category[...]]``
   Do not inventory the indicated categories of elements. (By default: "")

   *category* can take any of the following values:

   * ``Environment``: Environment variables
   * ``Printer``: Printers
   * ``Process``: System's processes (has no effect on Microsoft Windows systems)
   * ``Software``: Software
   * ``User``: Users

   If you indicate an empty string (""), all categories of elements will be
   inventoried.

``/no-html``
   This option is the opposite of ``/html``. See ``/html`` for more
   information.

``/no-httpd``
   Disables the embedded web server. (By default: No)

``/no-p2p``
   Do not use peer to peer to download files. (By default: No)

``/no-scan-homedirs``
   This option is the opposite of ``/scan-homedirs``. See
   ``/scan-homedirs`` for more information.

``/no-ssl-check``
   Do not check server certificate. (By default: No)

``/no-start-menu``
   Do not create the GLPI Agent folder on the Start Menu. (By
   default: No)

   The GLPI Agent folder will be available for all users, whenever it is created.

``/no-task=task[,task[...]]``
   Disables the given tasks. (By default: "")

   *task* can take any of the following values:

   * ``Deploy``: Task Deploy
   * ``ESX``: Task ESX
   * ``Inventory``: Task Inventory
   * ``NetDiscovery``: Task NetDiscovery
   * ``NetInventory``: Task NetInventory
   * ``WakeOnLan``: Task WakeOnLan

   If you indicate an empty string (""), all tasks will be executed.

``/p2p``
   This option is the opposite of ``/no-p2p``. See ``/no-p2p`` for more
   information.

``/password=password``
   Uses *password* as password for server authentication. (By default: "")

   The ``/password`` comes into play only if you have also indicated a
   value for the ``/server`` option.

``/proxy=URI``
   Uses *URI* as HTTP/S proxy server. (By default: "")

``/runnow``
   Launches the agent immediately after its installation. (By default: No)

``/S``
   Silent installation. (By default: No)

   You must accept the license in a explicit way (see ``/acceptlicense``)
   if you perform the installation in silent mode.

``/scan-homedirs``
   Allows the agent to scan home directories for virtual machines. (By
   default: No)

``/server``=URI[,URI[...]]``
   Sends results of tasks execution to given servers. (By default: "")

   If you indicate an empty string (""), the results of tasks execution
   will not be written remotely.

   You can use the ``/server`` and ``/local`` options simultaneously.

``/ssl-check``
   This option is the opposite of ``/no-ssl-check``. See ``/no-ssl-check``
   for more information.

``/start-menu``
   This option is the opposite of ``/no-start-menu``. See
   ``/no-start-menu`` for more information.

``/tag=tag``
   Marks the computer with the tag *tag* . (By default: "")

``/task-daily-modifier=modifier``
   Daily task schedule modifier. (By default: 1 day)

   *modifier* can take values between 1 and 30, both included.

   The ``/task-daily-modifier`` option comes into play only if you have
   also indicated ``Daily`` as value of the ``/task-frequency`` option.

``/task-frequency=frequency``
   Frequency for task schedule. (By default: ``Hourly``)

   *frequency* can take any of the following values:

   * ``Minute``: At minute intervals (see option ``/task-minute-modifier``)
   * ``Hourly``: At hour intervals (see option ``/task-hourly-modifier``)
   * ``Daily``: At day intervals (see option ``/task-daily-modifier``)

``/task-hourly-modifier=modifier``
   Hourly task schedule modifier. (By default: 1 hour)

   *modifier* can take values between 1 and 23, both included.

   The ``/task-hourly-modifier`` option comes into play only if you have
   also indicated ``Hourly`` as value of the ``/task-frequency`` option.

``/task-minute-modifier=modifier``
   Minute task schedule modifier. (By default: 15 minutes)

   *modifier* can take the following values: 15, 20 or 30.

   The ``/task-minute-modifier`` option comes into play only if you have
   also indicated ``Minute`` as value of the ``/task-frequency`` option.

``/timeout=timeout``
   Sets the limit time (in seconds) to connect with the server. (By
   default: 180 seconds)

   The ``/timeout`` option comes into play only if you have also indicated
   a value for the ``/server`` option.

``/user=user``
   Uses *user* as user for server authentication. (By default: "")

   The ``/user`` option comes into play only if you have also indicated a
   value for the ``/server`` option.