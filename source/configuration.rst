Configuration
=============

.. _system-location:

System location
---------------

On Unix, the agent reads its configuration from a configuration file named ``agent.cfg``, whose location depends of the installation method:

* ``/etc/glpi-agent/agent.cfg`` on :abbr:`FHS (File System Hierarchy)` compliant systems
* ``/Applications/GLPI-Agent/etc/agent.cfg`` on MacOS X pkg

More globally, you'll find that file in the GLPI Agent installation directory.

It is strongly discouraged to change this file, as you will probably loose your configuration on update (especially if you use a linux or MacOS X package).

Just ensure the ``include conf.d/`` is not commented (does not starts with a ``#``). Your specific configuration should then go to any ``conf.d/*.cfg`` file.

On Windows, the agent read its configuration from a registry key, whose location may depends on architecture:

* ``HKEY_LOCAL_MACHINE\SOFTWARE\GLPI-Agent`` is the default,
* ``HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\GLPI-Agent`` for 32bits agent installed on a 64bits system.

But windows portable version will use ``agent.cfg`` located under ``etc`` folder unless ``--config=registry`` option is used.

Parameter syntax
----------------

Most of the configuration options are single-valued; you can use a comma (``,``) as separator for multi-valued ones:

In configuration file:

.. code::

   logger = stderr,file

On command-line:

.. prompt:: bash

   glpi-agent --logger=stderr,file
   glpi-agent --logger stderr,file

Available parameters
--------------------

.. note::

   Most configuration options can be specified on command line ; this will override configuration file values in that case.

The only required configuration parameter is an execution target, which depends on the mode you will use:

* ``server``: a server URL, such as ``https://my-glpi-server/``, or ``https://my-glpi-server/front/inventory.php``,
* ``local``: full path for local directory, like ``/tmp/inventory``.

.. _server:

.. hint::

   If you're using `GLPI 10+ <https://glpi10.com/>`_, you may want to use `GlpiInventory plugin <https://plugins.glpi-project.org/#/plugin/glpiinventory>`_
   as a replacement for FusionInventory plugin **netdiscovery**, **netinventory**, **deploy**, **collect** and **esx** tasks management until this will be integrated in core.

.. caution::

   About the server URL to use as ``server`` parameter, it will depends on you server and plugins installation:

   * If you're using **GLPI 9.5.x** with **FusionInventory for GLPI plugin 9.5+3.0**:

    Your server URL should look like: ``https://my-glpi-server/plugins/fusioninventory/``

   * If you're using `GLPI 10+ <https://glpi10.com/>`_, there are few cases regarding `GlpiInventory plugin <https://plugins.glpi-project.org/#/plugin/glpiinventory>`_ usage:

    1. If you're not using **GlpiInventory plugin**:

     Your server URL should look like: ``https://my-glpi-server/``, or  ``https://my-glpi-server/front/inventory.php``
     
     Using ``https://my-glpi-server/`` may cause issues fixed in GLPI 10.0.6. If you use an older version, it may be better to use the full URL for now.

    2. If you have installed **GlpiInventory plugin** via **Marketplace**:

     Your server URL should look like: ``https://my-glpi-server/marketplace/glpiinventory/``

    3. If you have installed **GlpiInventory plugin** manually under ``/plugins`` GLPI folder:

     Your server URL should look like: ``https://my-glpi-server/plugins/glpiinventory/``

.. caution::

   In the case you installed your GLPI on IIS, you may need to add ``index.php`` at the end of your ``server`` parameter to use the right handler.
   But as explained by `@SteadEXE in an issue <https://github.com/glpi-project/glpi-agent/issues/314#issuecomment-1378421565>`_,
   you can fix this problem updating your IIS configuration.

``server``
    Specifies the server to use both as a controller for the agent, and as a
    recipient for task execution output.

    If the given value start with ``http://`` or ``https://``, it is assumed to be an URL,
    and used directly. Otherwise, it is assumed to be an hostname, and interpreted
    as ``http://hostname/inventory``.

    Multiple values can be specified, using a comma as a separator.

.. warning::

   Using multiple targets implies multiple executions of the same inventory ; this is not just a matter of targets. This can lead to different results, see :ref:`multiple-execution-targets`.

.. _local:

``local``
    Write the results of tasks execution locally.
    Exact behaviour according to given path:

     * if parameter is a directory, a file will be created therein
     * if parameter is a file, it will be used directly
     * if parameter is ``-``, **STDOUT** will be used

    Multiple values can be specified, using a comma as a separator.

.. warning::

   Using multiple targets implies multiple executions of the same inventory ; this is not just a matter of targets. This can lead to different results, see :ref:`multiple-execution-targets`.

.. _include:

``include``
    This directive can only be used from a configuration file and permits to specify a file or
    a path from where to load any ``*.cfg`` files.

    The default is ``conf.d`` to load any ``<INSTALLDIR>/etc/conf.d/*.cfg`` file.

.. _conf-reload-interval:

``conf-reload-interval``
    Automatically reload agent configuration after the given delay in seconds. The default
    is 0 which value just disables the feature.

.. _delaytime:

``delaytime``
    Specifies the upper limit, in seconds, for the initial delay before contacting
    the control server. The default is 3600.

    The actual delay is computed randomly between TIME / 2 and TIME seconds.

    This directive is used for initial contact only, and ignored thereafter in
    favor of server-provided value in response from prolog or Contact request.

.. _lazy:

``lazy``
    Do not contact the control server before next scheduled time.

    This directive is used when the agent is run in the foreground (not as
    a daemon) only.

.. _no-task:

``no-task``
    Disables given task.

    Multiple values can be specified, using a comma as a separator.

.. _tasks:

``tasks``
    Define tasks to run and in which order.

    Using ``...`` string in a list means run all remaining tasks.

    Multiple values can be specified, using a comma as a separator.

.. _proxy:

``proxy``
    Specifies the URL of the HTTP proxy to use. By default, the agent uses
    HTTP\_PROXY environment variable.

.. _user:

``user``
    Specifies the user to use for HTTP authentication on the server.

.. _password:

``password``
    Specifies the password to use for HTTP authentication on the server.

.. _oauth-client-id:

``oauth-client-id`` (Available since GLPI Agent v1.10)
    Specifies the GLPI OAuth2 client ID for server authentication.

.. attention::

    **OAuth2 authentication support** in GLPI for inventory submission is planned to
    be release with next GLPI major release, GLPI 11. The feature can be tested
    with `GLPI main version nightly builds <https://nightly.glpi-project.org/glpi/>`_.

    **OAuth clients credentials** have to be created in the dedicated **Configuration**
    panel in **GLPI 11** and greater with "**Client credentials**" as **Grants** value
    and "**inventory**" as **Scope** value.

.. _oauth-client-secret:

``oauth-client-secret`` (Available since GLPI Agent v1.10)
    Specifies the GLPI OAuth2 client secret for server authentication.

.. _ca-cert-dir:

``ca-cert-dir``
    Specifies the directory containing indexed Certification Authority (CA)
    certificates.

    This directory must contain the certificate files corresponding to different
    certificate authorities in Privacy Enhanced Mail (PEM) format. The file name
    of each certificate file must match the hash value of the certificate's
    *subject* field and use the ``.0`` extension.

    You can obtain the hash value of the certificate's *subject* field and copy
    the *CA.crt* certificate to the expected place following this snippet:

    .. code::

        $ CA_CERT_DIR=/etc/glpi-agent/ca-cert-dir
        $ openssl x509 -in CA.crt -subject_hash -noout
        b760f1ce
        * cp -a CA.crt $CA_CERT_DIR/b760f1ce.0

.. _ca-cert-file:

``ca-cert-file``
    Specifies the file containing aggregated Certification Authority (CA)
    certificates.

.. _ssl-cert-file:

``ssl-cert-file``
    Specifies the file containing SSL client certificate to use when connecting to
    server target or for WinRM remote inventory.

.. _ssl-fingerprint:

``ssl-fingerprint`` (Available since GLPI Agent v1.3)
    Specifies the fingerprint of the ssl server certificate to trust.

    The fingerprint to use can be retrieved in agent log by temporarily enabling
    `no-ssl-check` option.

.. _ssl-keystore:

``ssl-keystore`` (Available since GLPI Agent v1.11)
    Keystore support on Windows, Keychain support on MacOSX and CA trust store support on Unix/Linux 
    are enabled by default to provide a way to authentify SSL GLPI server if CA certificate or server 
    certificate is integrated there. The default CA bundle from Mozilla's will be included only if the
    GLPI-Agent is unable to extract certificates from the operating system. (this support case is available since GLPI Agent v1.12)

    It takes as argument a string which can be a list separated by commas:

    * ``none``: just disable Mozilla::CA bundle and keystore support on Windows, keychain support on MacOSX or CA trust store on Unix/Linux.
    * Only on Windows, any combination of the following **case-sensitive** keys:

      * ``My``, ``CA``, ``Root`` for default machine store
      * ``User-My``, ``User-CA``, ``User-Root`` for machine user store
      * ``Service-My``, ``Service-CA``, ``Service-Root`` for machine service store
      * ``Enterprise-My``, ``Enterprise-CA``, ``Enterprise-Root`` for machine enterprise store
      * ``GroupPolicy-My``, ``GroupPolicy-CA``, ``GroupPolicy-Root`` for machine group policy store

    * Only on MacOSX, the user ('root' as a daemon) keychain will be used. You can use only the system keychain by using the ``system-ssl-ca`` key. (this option in not supported until v1.12)

    By default, only ``CA`` and ``Root`` keystores for the machine's default, user ('LocalSystem' as a service), service, enterprise and 
    group policy stores are exported on Windows.

    On Unix/Linux, the agent uses the OpenSSL CA trust store (/etc/ssl/certs/ca-certificates.crt). (this option in not supported until v1.12)

    GLPI-Agent will use `certutil command <https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/certutil>`_
    and `security find-certificates command <https://ss64.com/mac/security-find-cert.html>`_ to extract certificates from related store.

    This option will be ignored if used at the same time than one of ``ca-cert-dir``, ``ca-cert-file`` or ``ssl-fingerprint`` options.

.. _no-ssl-check:

``no-ssl-check``
    Disables server SSL certificate validation. The default is 0 (false).

.. _timeout:

``timeout``
    Specifies a timeout, in seconds, for server connections.

.. _no-httpd:

``no-httpd``
    Disables the embedded web interface, used to receive execution requests from the
    GLPI server or serve httpd plugins. The default is 0 (false).

.. _httpd-ip:

``httpd-ip``
    Specifies the network interface to use for the embedded web interface. The
    default is to use all available ones.

.. _httpd-port:

``httpd-port``
    Specifies the network port to use for the embedded web interface. The default
    is 62354.

.. _httpd-trust:

``httpd-trust``
    Specifies which IP address should be trusted, for execution requests. The
    default is to only accept requests from the control servers.

    All formats supported by `Net::IP <https://metacpan.org/pod/Net::IP>`_ can be used (IP addresses, IP addresses
    ranges, networks in CIDR notatation), as well as hostnames.

    Multiple values can be specified, using a comma as a separator.

.. _logger:

``logger``
    Specifies the logger backend to use. The possible values are:

    - file: log messages in a file.
    - stderr: log messages directly in the console.
    - syslog: log messages through the local syslog server.

    Multiple values can be specified, using a comma as a separator.

.. _logfile:

``logfile``
    Specifies the file to use for the file logger backend.

.. _logfile-maxsize:

``logfile-maxsize``
    Specifies the maximum size for the log file, in MB.  When the max size is
    reached, the file is truncated. The default is unlimited.

.. _logfacility:

``logfacility``
    Specifies the syslog facility to use for the syslog logger backend. The default
    is LOG\_USER.

.. _color:

``color``
    Enables color display for the stderr logger backend.

    This directive is used on Unix only.

.. _debug:

``debug``
    Specifies the level of verbosity for log content. The possible values are:

    - 0: basic agent processing
    - 1: extended agent processing
    - 2: messages exchanged with the server and activates traces from Net::SSLeay if used

.. _no-compression:

``no-compression``
    Disable compression when exchanging informations with GLPI Server. The default is to compress data.

    This directive is only supported when server option is set.

.. _listen:

``listen``
    Force agent to always listen for requests on httpd interface, even when no target is defined with
    server or local option.

    This directive does nothing if server or local option is set.

.. _vardir:

``vardir``
    Set dedicated ``vardir`` path as agent storage. The default is ``<INSTALLDIR>/var`` on MacOSX, win32 or source install
    and generally ``/var/lib/glpi-agent`` on linux/unix when installed with a package.

Task-specific parameters
------------------------

.. _tag:

``tag``
    Specifies an arbitrary string to add to output. This can be used as an
    additional decision criteria on server side.

    This directive is only for inventory or esx task only.

.. _no-category:

``no-category``
    Disables given category in output. The possible values can be listed running ``glpi-agent --list-categories``.
    Some available categories:

    - printer
    - software
    - environment
    - process
    - user

    Multiple values can be specified, using a comma as a separator.

    This directive is used for inventory task only.

.. _full-inventory-postpone:

``full-inventory-postpone`` (Available since GLPI Agent v1.8)
    Specifies the number of times the agent can decide to report a full inventory and produce a partial inventory
    which only includes changed categories. The default is 14.

    This feature is only supported when using json as inventory format so GLPI 10 is required as server. This can reduce
    a lot the GLPI workload and can help to reduce GLPI server carbon footprint.

    It can be set to 0 to disable the feature and to always produce full inventory as before 1.8.

.. _additional-content:

``additional-content``
    Specifies an XML file whose content will be automatically merged with output. If inventory format is JSON, you can
    also specify a JSON file from which ``content`` base node will be merged.

    This directive is used for inventory task only.

.. _scan-homedirs:

``scan-homedirs``
    Enables scanning user home directories for virtual machines (Any OS) or licenses (MacOS X only) . The default is 0
    (false).

    This directive is used for inventory task only.

.. _scan-profiles:

``scan-profiles``
    Enables scanning profiles for softwares installation (Win32). The default is 0
    (false).

    This directive is used for inventory task only.

.. _force:

``force``
    Execute the task, even if not required by the server.

    This directive is used for inventory task only.

.. _backend-collect-timeout:

``backend-collect-timeout``
    Specifies the timeout in seconds for task modules execution. The default is 300.

    This directive is used for inventory task only.

.. _no-p2p:

``no-p2p``
    Disables peer to peer for downloading files.

    This directive is used for deploy task only.

.. _html:

``html``
    Output inventory in HTML format.

    This directive is used for inventory task and for local target only.

.. _json:

``json``
    Use JSON as inventory format.

    This directive is used for inventory task.

.. _remote:

``remote``
    Specify a remote inventory definition to be used by :doc:`../tasks/remote-inventory` task.

``remote-workers`` (Available since GLPI Agent v1.5)
    Specify the maximum number of remote inventory the agent can process at the same time.

    By default, only one remote inventory can be processed at a given time.

.. _assetname-support:

``assetname-support`` (Available since GLPI Agent v1.5)
   On unix/linux, this option permits to decide how the computer should be named while
   referencing the computer name. This option can be set to a numeric value:

       - ``1`` (the default) means to use the short name
       - ``2`` means to leave the found hostname unchanged, this can be a Fully Qualified Domain Name (FQDN)
         or a short name depending on the system
       - ``3`` means to always try to use the FQDN (this support case is available since GLPI Agent v1.7)

   MacOSX & Win32 platforms don't support this option.

   For remoteinventory, this option in not supported until v1.6.1. And later, the ``3`` value support for FQDN needs
   `perl` to be installed on the remote computer and ``perl`` mode enabled on the defined remote for the RemoteInventory task.

   Until v1.6.1, this option only affect the computer name as seen in GLPI Assets list. After, it will also be used
   to decide how agent reports its `deviceid` to GLPI.

.. _snmp-retries:

``snmp-retries`` (Available since GLPI Agent v1.9)
    Set the maximum number of time a SNMP request could be retried again after no device response. The default is 0.

    This directive is used for netdiscovery et netinventory tasks.

.. caution::

    ``snmp-retries`` can make snmp inventories more longer to achieve. Use only if you find a device sometime is really not answering in time.
