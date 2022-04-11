Linux AppImage Installer
^^^^^^^^^^^^^^^^^^^^^^^^

Linux `AppImage <https://appimage.org/>`_ installer is another way to install glpi-agent on linux.
It has the advantage to work on any linux supporting AppImage format (most linux distros since years).

To install the agent, just run:

.. prompt:: bash
   :substitutions:

   chmod +x glpi-agent-|version|-x86_64.AppImage
   sudo ./glpi-agent-|version|-x86_64.AppImage --install --server <URL>

At this point, if you obtain an error explaining ``AppImages require FUSE to run.``,
you still can try a :ref:`manual install <manual-install>`.

To upgrade the agent if you still installed glpi-agent linux appimage, just run:

.. prompt:: bash
   :substitutions:

   chmod +x glpi-agent-|version|-x86_64.AppImage
   sudo ./glpi-agent-|version|-x86_64.AppImage --upgrade

By default, the agent is installed under ``/usr/local/bin`` and dedicated configuration is created under ``/etc/glpi-agent/conf.d``.

To uninstall the agent, you simply can run:

.. prompt:: bash

   sudo glpi-agent-uninstall

Or to also clean any data in ``/etc/glpi-agent`` and ``/var/lib/glpi-agent``:

.. prompt:: bash

   sudo glpi-agent-uninstall --clean

Installer parameters
''''''''''''''''''''

.. hint::

   You can retrieve all available parameters running:

   .. prompt:: bash
      :substitutions:

      ./glpi-agent-|version|-x86_64.AppImage --help

``--install``
   Install the agent by coping AppImage to install path, creating binding scripts
   for GLPI Agent commands.
   It copies default configurations and creates dedicated configuration to setup
   the agent with configuration parameters.

``-i --installpath=PATH``
   Define ``PATH`` as installation folder. (By default: ``/usr/local/bin``)

``--upgrade``
   Try to just upgrade the currently installed agent, keeping configuration and
   trying to restart the agent.

``--upgrade``
   Like upgrade but involves ``--clean`` option to make a clean install, resetting
   the configuration.

``--uninstall``
   Try to uninstall currently installed Glpi Agent AppImage.

``--config=PATH``
   When installing, copy the given configuration file in ``/etc/glpi-agent/conf.d``

``--clean``
   Clean everything when uninstalling or before installing.

``--runnow``
   Run agent tasks after installation.

``--service``
   Install GLPI Agent AppImage as a service. This option is selected by default.

``--no-service``
   Don't install GLPI Agent as a service.

``--cron=SCHED``
   Install agent as cron task (no by default).
   ``SCHED`` can only be set to ``daily`` or ``hourly``.

``--version``
   Output the installer version and exit.

``-S --silent``
   Make installer silent.

``-h --help``
   Output help and exit.

``--script=SCRIPT``
   Run embedded script in place of installer.

``--perl``
   Run embedded perl.

Configuration parameters
''''''''''''''''''''''''

All configuration options are documented in :doc:`../configuration` page and in the
:doc:`../man/glpi-agent` man page.

Target options
~~~~~~~~~~~~~~

Most importantly, at least one target definition option is mandatory when installing GLPI Agent.

:ref:`-s --server=URI <server>`
   send tasks result to a server

:ref:`-l --local=PATH <local>`
   write tasks results locally in a file

Scheduling options
~~~~~~~~~~~~~~~~~~

:ref:`--delaytime=LIMIT <delaytime>`
   maximum delay before running target tasks the first time

:ref:`--lazy <lazy>`
   do not contact the target before next scheduled time

Task selection options
~~~~~~~~~~~~~~~~~~~~~~

:ref:`--no-task=TASK[,TASK]... <no-task>`
   do not run given task

:ref:`--tasks=TASK1[,TASK]...[,...] <tasks>`
   run given tasks in given order

Inventory task specific options
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:ref:`--no-category=CATEGORY <no-category>`
   do not include given categories in inventory

:ref:`--scan-homedirs <scan-homedirs>`
   scan user home directories

:ref:`--scan-profiles <scan-profiles>`
   scan user profiles

:ref:`--html <html>`
   save inventory as HTML

:ref:`--json <json>`
   save inventory as JSON

:ref:`--force <force>`
   always send data to server

:ref:`--backend-collect-timeout=TIME <backend-collect-timeout>`
   timeout for inventory modules execution

Remote inventory task specific options
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:ref:`--remote=REMOTE <remote>`
   setup remote for which request remote inventory

Deploy task specific options
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:ref:`--no-p2p <no-p2p>`
   do not use peer to peer to download files

Network options
~~~~~~~~~~~~~~~

:ref:`--proxy=PROXY <proxy>`
   proxy address

:ref:`--user=USER <user>`
   user name for server authentication

:ref:`--password=PASSWORD <password>`
   password for server authentication

:ref:`--ca-cert-dir=DIRECTORY <ca-cert-dir>`
   CA certificates directory

:ref:`--ca-cert-file=FILE <ca-cert-file>`
   CA certificate file

:ref:`--ssl-cert-file=FILE <ssl-cert-file>`
   Client certificate file

:ref:`--no-ssl-check <no-ssl-check>`
   do not check server SSL certificate

:ref:`-C --no-compression <no-compression>`
   do not compress communication with server

:ref:`--timeout=TIME <timeout>`
   connection timeout

Web interface options
~~~~~~~~~~~~~~~~~~~~~

:ref:`--no-httpd <no-httpd>`
   disable embedded web server

:ref:`--httpd-ip=IP <httpd-ip>`
   local network ip to listen on

:ref:`--httpd-port=PORT <httpd-port>`
   network port to listen on

:ref:`--httpd-trust=IP <httpd-trust>`
   trust given IPs and IP ranges

:ref:`--listen <listen>`
   enable listener target if required

Logging options
~~~~~~~~~~~~~~~

:ref:`--logger=BACKEND <logger>`
   logger backend

:ref:`--logfile=FILE <logfile>`
   log file

:ref:`--logfile-maxsize=SIZE <logfile-maxsize>`
   maximum size of the log file

:ref:`--logfacility=FACILITY <logfacility>`
   syslog facility

:ref:`--color <color>`
   use color in the console

:ref:`--debug <debug>`
   enable debug mode

General options
~~~~~~~~~~~~~~~

:ref:`--conf-reload-interval=TIME <conf-reload-interval>`
   number of seconds between two configuration reloading

:ref:`-t --tag=TAG <tag>`
   add given tag to inventory results

:ref:`--vardir=PATH <vardir>`
   use specified path as storage folder for agent persistent datas

.. _manual-install:

Manual install
''''''''''''''

In the case, FUSE is not installed on the system and you can't or don't want to install it,
you still can install GLPI Agent manually by following these steps:

* Extract AppImage content:

   .. prompt:: bash
      :substitutions:

      ./glpi-agent-|version|-x86_64.AppImage --appimage-extract

   This will extract the content into a ``squashfs-root`` subfolder.

* Copy the squashfs-root folder to a dedicated place:

   .. prompt:: bash

      [ -d /opt ] || sudo mkdir /opt
      sudo rm -rf /opt/glpi-agent
      sudo cp -r squashfs-root /opt/glpi-agent

* Run the ``AppRun`` from copied folder as installer:

   .. prompt:: bash

      sudo /opt/glpi-agent/AppRun --install --server <URL>

To uninstall after a manual install, you need to run:

   .. prompt:: bash

      sudo /usr/local/bin/glpi-agent-uninstall
      sudo rm -rf /opt/glpi-agent

Portable installation
'''''''''''''''''''''

It is possible to use AppImage installer to create a portable linux glpi agent environment.

Creation
~~~~~~~~

Here are the step to install such environment:

1. Download `glpi-agent-portable.sh <https://raw.githubusercontent.com/glpi-project/glpi-agent/develop/contrib/unix/glpi-agent-portable.sh>`_
2. Download a GLPI Agent AppImage
3. Copy script and AppImage to a dedicated folder, for example at the root of an USB key or a network shared folder
4. Make script and AppImage executable with:

   .. prompt:: bash

      sudo chmod +x glpi-agent-portable.sh glpi-agent*.AppImage

5. Run one time ``glpi-agent-portable.sh`` to setup the environment.
   This will create a ``etc/`` and a ``var/`` subfolder and all scripts at the same level.
   Don't remove ``glpi-agent-portable.sh`` and AppImage.

   .. prompt:: bash

      sudo ./glpi-agent-portable.sh

6. Create a ``.cfg`` file under ``etc/conf.g`` to configure your agent or
   create dedicated script which start expected glpi-agent scripts with expected parameters.

You're now ready to use the linux portable agent.

.. note::

   As installed scripts are using :ref:`--vardir=PATH <vardir>` option, agent deviceid will be defined depending on the current computer hostname.
   So you can safely run it on different computers. The deviceid will even be reused later if you run it again on a given computer.

.. hint::

   You can also specify AppImage to use by defining ``APPIMAGE`` environment variable.

Upgrade
~~~~~~~

It is really simple to upgrade a portable installation:

1. Remove old AppImage from the folder
2. Download and copy the newer AppImage
3. Make AppImage executable

   .. prompt:: bash

      sudo chmod +x glpi-agent*.AppImage
