Configuration
=============

System location
---------------

On Unix, the agent reads its configuration from a configuration file named ``agent.cfg``, whose location depends of the installation method:

* ``/etc/glpi-agent/agent.cfg`` on :abbr:`FHS (File System Hierarchy)` compliant systems
* ``/Applications/GLPI-Agent/etc/agent.cfg`` on MacOS X pkg

More globally, you'll find that file in the GLPI Agent installation directory.

It is strongly discouraged to change this file, as it would prevent it to be updated (especially if you use a linux or MacOS X package).

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

* ``server``: a server URL, such as ``https://glpi/front/inventory.php``,
* ``local``: full path for local directory, like ``/tmp/inventory``.

.. warning::

   Using multiple targets implies multiple executions of the same inventory ; this is not just a matter of targets. This can lead to different results, see :ref:`multiple-execution-targets`.

``server``
    Specifies the server to use both as a controller for the agent, and as a
    recipient for task execution output.

    If the given value start with ``http://`` or ``https://``, it is assumed to be an URL,
    and used directly. Otherwise, it is assumed to be an hostname, and interpreted
    as ``http://hostname/inventory``.

    Multiple values can be specified, using a comma as a separator.

``include``
    This directive can only be used from a configuration file and permits to specify a file or
    a path from where to load any ``*.cfg`` files. The default is ``conf.d`` to load any
    ``<INSTALLDIR>/etc/conf.d/*.cfg`` file.

``conf-reload-interval``
    Automatically reload agent configuration after the given delay in seconds. The default
    is 0 which value just disables the feature.

``delaytime``
    Specifies the upper limit, in seconds, for the initial delay before contacting
    the control server. The default is 3600.

    The actual delay is computed randomly between TIME / 2 and TIME seconds.

    This directive is used for initial contact only, and ignored thereafter in
    favor of server-provided value in response from prolog or Contact request.

``lazy``
    Do not contact the control server before next scheduled time.

    This directive is used when the agent is run in the foreground (not as
    a daemon) only.

``no-task``
    Disables given task.

    Multiple values can be specified, using a comma as a separator.

``proxy``
    Specifies the URL of the HTTP proxy to use. By default, the agent uses
    HTTP\_PROXY environment variable.

``user``
    Specifies the user to use for HTTP authentication on the server.

``password``
    Specifies the password to use for HTTP authentication on the server.

``ca-cert-dir``
    Specifies the directory containing indexed Certification Authority (CA)
    certificates.

``ca-cert-file``
    Specifies the file containing aggregated Certification Authority (CA)
    certificates.

``no-ssl-check``
    Disables server SSL certificate validation. The default is 0 (false).

``timeout``
    Specifies a timeout, in seconds, for server connections.

``no-httpd``
    Disables the embedded web interface, used to receive execution requests from the
    server. The default is 0 (false).

``httpd-ip``
    Specifies the network interface to use for the embedded web interface. The
    default is to use all available ones.

``httpd-port``
    Specifies the network port to use for the embedded web interface. The default
    is 62354.

``httpd-trust``
    Specifies which IP address should be trusted, for execution requests. The
    default is to only accept requests from the control servers.

    All formats supported by [Net::IP](https://metacpan.org/pod/Net::IP) can be used (IP addresses, IP addresses
    ranges, networks in CIDR notatation), as well as hostnames.

    Multiple values can be specified, using a comma as a separator.

``logger``
    Specifies the logger backend to use. The possible values are:

    - file: log messages in a file.
    - stderr: log messages directly in the console.
    - syslog: log messages through the local syslog server.

    Multiple values can be specified, using a comma as a separator.

``logfile``
    Specifies the file to use for the file logger backend.

``logfile-maxsize``
    Specifies the maximum size for the log file, in MB.  When the max size is
    reached, the file is truncated. The default is unlimited.

``logfacility``
    Specifies the syslog facility to use for the syslog logger backend. The default
    is LOG\_USER.

``color``
    Enables color display for the stderr logger backend.

    This directive is used on Unix only.

``debug``
    Specifies the level of verbosity for log content. The possible values are:

    - 0: basic agent processing
    - 1: extended agent processing
    - 2: messages exchanged with the server and activates traces from Net::SSLeay if used

``no-compression``
    Disable compression when exchanging informations with GLPI Server. The default is to compress data.

    This directive is only supported when server option is set.

``listen``
    Force agent to always listen for requests on httpd interface, even when no target is defined with
    server or local option.

    This directive does nothing if server or local option is set.

``vardir``
    Set dedicated ``vardir`` path as agent storage. The default is ``<INSTALLDIR>/var`` on MacOSX, win32 or source install
    and generally ``/var/lib/glpi-agent`` on linux/unix when installed with a package.

Task-specific parameters
------------------------

``tag``
    Specifies an arbitrary string to add to output. This can be used as an
    additional decision criteria on server side.

    This directive is only for inventory or esx task only.

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

``additional-content``
    Specifies an XML file whose content will be automatically merged with output. If inventory format is JSON, you can
    also specify a JSON file from which ``content`` base node will be merged.

    This directive is used for inventory task only.

``scan-homedirs``
    Enables scanning user home directories for virtual machines (Any OS) or licenses (MacOS X only) . The default is 0
    (false).

    This directive is used for inventory task only.

``scan-profiles``
    Enables scanning profiles for softwares installation (Win32). The default is 0
    (false).

    This directive is used for inventory task only.

``force``
    Execute the task, even if not required by the server.

    This directive is used for inventory task only.

``collect-timeout``
    Specifies the timeout for task modules execution.

    This directive is used for inventory task only.

``no-p2p``
    Disables peer to peer for downloading files.

    This directive is used for deploy task only.

``html``
    Output inventory in HTML format.

    This directive is used for inventory task and for local target only.

``json``
    Use JSON as inventory format.

    This directive is used for inventory task.

