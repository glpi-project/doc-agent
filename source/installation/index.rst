Installation
============

The latest release is available from `our github releases page <https://github.com/glpi-project/glpi-agent/releases>`_.

.. note::

   In the case you're replacing `FusionInventory agent <https://fusioninventory.org/>`_ with GLPI Agent, you should first uninstall **FusionInventory agent**
   before installing **GLPI Agent**. You can use the same dedicated configuration if you placed it in `conf.d` configuration subfolder.

.. hint::

   Nightly builds are also available from `our dedicated GLPI-Agent Nightly Builds page <https://nightly.glpi-project.org/glpi-agent>`_.

Windows
-------

.. toctree::
   :maxdepth: 3
   :hidden:

   Windows installer <windows-command-line>

The installer integrates its native, although reduced but recent, version of `Strawberry Perl <https://strawberryperl.com/>`_ including recent `OpenSSL support <https://www.openssl.org/>`_.

You can download the lastest `GLPI Agent installer <https://github.com/glpi-project/glpi-agent/releases>`_ or `current nightly build <https://nightly.glpi-project.org/glpi-agent>`_. It is available for both 32 and 64 bits systems and provides a graphical interface as well as command line facilities.

By default, it will perform a graphical installation, unless you use the msiexec `/i` and `/quiet` options. All installer parameters are described in :doc:`./windows-command-line` dedicated page.

.. note::

   All graphical installer options are related to a command line one. Check :doc:`./windows-command-line` if you need help.

Large Installations
^^^^^^^^^^^^^^^^^^^

Consider a scenario where the GLPI Agent application needs to be installed on large and diverse range of Windows systems. A VBScript can be useful in this scenario to perform the following tasks:

- Install it silently taking variables from the installation script previously configured.
- Check for the presence of FusionInventory and OCS Inventory agents and uninstall them if you need it.
- Configure application settings based on `command line parameters that can be explored here <windows-command-line.html#command-line-parameters>`_.
- Log installation progress and errors for review and analysis.

A VBScript (Visual Basic Script) is provided to deploy the installer on a network:
:download:`glpi-agent-deployment.vbs <https://raw.github.com/glpi-project/glpi-agent/develop/contrib/windows/glpi-agent-deployment.vbs>`.

In this script you'll find some variables that can be changed to your environment needings (uncomment what is commented and you need. Comment what you don't need.):

- **GLPI Agent Version** hereby named ``SetupVersion``
- Setup the **Location** from where the script will download the MSI hereby named ``SetupLocation``. It can be a HTTP or HTTPS url, a CIFS or local folder. The default is to use the github release page url.
- Setup the **Architecture of your systems** (if you need it to be x86, x64, or if you want to let it be installed according to the system Architecture) hereby named ``SetupArchitecture``
- **Setup Options** from the `command line parameters <windows-command-line.html#command-line-parameters>`_:

  - It is recommended to keep the ``/quiet`` parameter so the user will not be bothered with wizard or command line messages or windows
  - If you want to follow all the steps of installations, don't add the ``/quiet`` parameter.
- **Reconfigure**:

  - You will just set this up to Yes if the current installed agent has the same version you have configured on the ``SetupVersion`` above. This option, when activated, is going to reconfigure the new options for the same Agent.
  - It's useful when you just need to change a parameter like GLPI ``SERVER`` url, for example.
- **Repair**:

  - This option will unregister and register the MSI service DLL, and reinstall it with the options selected on the script.
  - It works just when the Setup is still installed.
- **Verbose**:

  - It Enables or Disables
- **Run uninstall**:

  - Here you can uncomment the deprecated agents you want the script to uninstall (FusionInventory Agent or OCSInventory Agent)

.. hint::
   Adding this VBS Script to a Computer GPO to run on startup of computers, usually works better, since there are some users with no installation rights.
   The msi download should be accessible for every computer that needs to execute it. If you are using a local network sharing, or a regular Github URL, you must make sure the computers are able to download it from the original source.

Contributions
^^^^^^^^^^^^^

Glpi-Agent Monitor
~~~~~~~~~~~~~~~~~~

`Leonardo Bernardes <https://github.com/redddcyclone>`_ published **Glpi-Agent Monitor** tool which provides a systray icon to survey the agent status and permit to ask a tasks run.

You can download it from the `Glpi-Agent Monitor <https://github.com/glpi-project/glpi-agentmonitor/releases>`_ project release page.
You simply have to download the exe into any folder (the Glpi-Agent installation folder is just fine) and start it.

If you want to add it to all users auto-started softwares, you can directly install it into the **C:\\ProgramData\\Microsoft\\Windows\\Start Menu\\Programs\\StartUp** folder.

.. hint::

   **Glpi-Agent Monitor** has been integrated into **GLPI-Agent MSI installer** and can be enabled using :ref:`AGENTMONITOR=1 <agent-monitor>` on the MSI commandline. When installed this way, you don't need to copy it manually and it starts when a user is logs in.

MacOS
-----

The installer integrates its native, although reduced but recent, version of `Perl <https://www.perl.org/>`_ including recent `OpenSSL support <https://www.openssl.org/>`_.

Get the latest ``.pkg`` package from `our releases page <https://github.com/glpi-project/glpi-agent/releases>`_ or the `nightly build page <https://nightly.glpi-project.org/glpi-agent>`_. After installing it, you'll have to configure the agent to your needs by creating a dedicated ``.cfg`` file under the ``/Applications/GLPI-Agent/etc/conf.d`` folder.

You can for example create a ``local.cfg`` file and :

* add the ``server = GLPI_URL`` line to point to your GLPI server,
* eventually set ``debug = 1`` to generate some debug in logs,
* set a ``tag`` like ``tag = MyLovelyTag``.

.. hint::

   A MacOSX installation video tutorial is available here: `GLPI Agent Demonstration - macOS Monterey - Apple M1 <https://www.youtube.com/watch?v=zFYcURQNh9k>`_

GNU/Linux
---------

We support major distros as we provides generic packages for **RPM** and **DEB** based distros as well if they supports **Snap** packaging. You can install required packages after getting them from `our github releases page <https://github.com/glpi-project/glpi-agent/releases>`_ or the `nightly build page <https://nightly.glpi-project.org/glpi-agent>`_.

.. hint::

   When possible, prefer to use our :ref:`linux perl installer <linux-installer>` as it supports **RPM** and **DEB** based distros. There's a version also including the **Snap** package.
   The linux installer accepts few options to configure the agent so it can simplify manual or automatic installation.
   It also can be handy for tools like `Puppet`_ or `Ansible`_.

.. _Puppet: https://puppet.com/open-source/#osp

.. _Ansible: https://www.ansible.com/community

Linux AppImage installer
^^^^^^^^^^^^^^^^^^^^^^^^

.. toctree::
   :maxdepth: 4
   :hidden:

   GLPI Agent AppImage <linux-appimage>

.. hint::

    When not sure or linux perl installer doesn't support your distro, try Linux AppImage installer.

    See :doc:`Linux AppImage installer dedicated page <linux-appimage>`

Snap
^^^^

The `Snapcraft`_ **Snap** package integrates its native, although reduced but recent, version of `Perl <https://www.perl.org/>`_ including recent `OpenSSL support <https://www.openssl.org/>`_.

If your system support **Snap**, you can simply install the agent with the ``snap`` command after getting the **Snap** package from `our releases page <https://github.com/glpi-project/glpi-agent/releases>`_ or the `nightly build page <https://nightly.glpi-project.org/glpi-agent>`_. Then, you just have to run:

.. prompt:: bash
   :substitutions:

   snap install --classic --dangerous GLPI-Agent-|version|_amd64.snap

After installation, you can easily configure the agent with the **set** ``snap`` sub-command:

.. prompt:: bash

   snap set glpi-agent server=http://my-glpi-server/

Any supported glpi-agent option can be set this way. If you need to unset a configuration parameter, just set it empty:

.. prompt:: bash

   snap set glpi-agent tag=

.. note::

   You won't find the package in the `Snapcraft`_ store as their standard policies are too restrictive for GLPI Agent features and requirements.

.. _Snapcraft: https://snapcraft.io/

.. _linux-installer:

Linux Perl Installer
^^^^^^^^^^^^^^^^^^^^

.. attention::

   The **linux installer** main requirement is the **perl** command.

   It also requires one of the following command, depending on the targeted system:

    - **dnf** for recent **RPM** based systems
    - **yum** for previous generation of **RPM** based systems
    - **apt** for **DEB** based systems like Debian & Ubuntu
    - **snap** for other systems supporting `Snapcraft`_ **Snap** packages

We also provide a dedicated linux installer which includes all the packages we build (**RPM** & **DEB**) and eventually the `snap <#snap>`_ one.
On supported distros (**DEB** & **RPM** based), the installer will also eventually try to enable third party repositories, like EPEL on CentOS if they are required.

The installer is a simple perl script. It supports few options to configure the agent during installation. You can check all supported options by running:

.. prompt:: bash
   :substitutions:

   perl glpi-agent-|version|-linux-installer.pl --help

or if you use the installer embedding **snap** package:

.. prompt:: bash
   :substitutions:

   perl glpi-agent-|version|-with-snap-linux-installer.pl --help

If your GNU/Linux distro is not supported, you still can :ref:`install it from sources <install-from-sources>`.

Unofficial repositories
^^^^^^^^^^^^^^^^^^^^^^^

.. attention::

   Unofficial repositories are not supported by GLPI-Agent editor. Use them at your own risk.

Thanks to ligenix, a COPR repository can be used to install glpi-agent on Fedora 35 & 36, CentOS Stream 8 & 9, EPEL 7, 8 & 9: `ligenix/enterprise-glpi10  <https://copr.fedorainfracloud.org/coprs/ligenix/enterprise-glpi10/>`_

.. _install-from-sources:

From sources
------------

.. note::

   We strongly recommend the use of `GNU tar` because some file path length are
   greater than 100 characters. Some tar version will silently ignore those files.

First, you need to extract the source and change the current directory.

.. prompt:: bash
   :substitutions:

   tar xfz GLPI-Agent-|version|.tar.gz
   cd GLPI-Agent-|version|

Executing ``Makefile.PL`` will verify all the required dependencies are available
and prepare the build tree.

.. prompt:: bash

   perl Makefile.PL

If you don't want to use the default directory (``/usr/local``), you can use the
``PREFIX`` parameter:

.. prompt:: bash

   perl Makefile.PL PREFIX=/opt/glpi-agent

.. note::

   At this point, you may have some missing required modules. See `PERL Dependencies`_
   section for installing them. Once this is done, run the same command again.

You now can finish the installation. Here again we recommend `GNU make` (`gmake`):

.. prompt:: bash

   make
   make install

Tests
^^^^^

.. note::

   The tests suite requires some additional dependencies like Test::More.

GLPI agent comes with a test-suite. You can run it with this command:

.. prompt:: bash

   make test

Perl dependencies
^^^^^^^^^^^^^^^^^

The easiest way to install `perl <https://www.perl.org/>`_ dependencies is to use `cpanminus <https://cpanmin.us/>`_ script, running:

.. prompt:: bash

   cpanm .

You can use the ``--notest`` flag if you are brave and want to skip the tests suite execution for each install perl module.

Offline installations
^^^^^^^^^^^^^^^^^^^^^

.. note::

   This requires the cpanminus script to be installed.

First grab the tarball from the website and extract it:

.. prompt:: bash
   :substitutions:

   tar xzf GLPI-Agent-|version|.tar.gz
   cd GLPI-Agent-|version|

We use ``cpanm`` to fetch and extract the dependencies in the extlib directory:

.. prompt:: bash

   cpanm --pureperl --installdeps -L extlib --notest .

If this command fails with an error related to ``Params::Validate``, then just run
this last command:

.. prompt:: bash

   cpanm --installdeps -L extlib --notest .

Now you can copy the directory to another machine and run the agent this way:

.. prompt:: bash

   perl -Iextlib/lib/perl5 -Ilib glpi-agent

Other dependencies
^^^^^^^^^^^^^^^^^^

On Solaris/SPARC, you must install `sneep <https://docs.oracle.com/cd/E35557_01/doc.81/e35226/ch3_sneep.htm#IGSTB133>`_ and record the Serial Number with it.

On Windows, we use an additional ``dmidecode`` binary shipped in the windows MSI
package to retrieve many information not available otherwise, including
fine-grained multi-cores CPUs identification. Unfortunately, this binary is not
reliable enough to be used on Windows 2003, leading to less precise
inventories.

On Linux, ``lspci`` will be used to collect PCI, AGP, PCI-X, ... information.
