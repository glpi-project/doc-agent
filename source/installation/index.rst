Installation
============

.. attention::

   As of this writing, GLPI Agent was not officialy released so the github releases page remains empty.
   Anyway you still can download development builds from `our GLPI-Agent Nightly Builds page <https://nightly.glpi-project.org/glpi-agent>`_.

The latest release will be available from `our github releases page <https://github.com/glpi-project/glpi-agent/releases>`_.

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

A VBScript (Visual Basic Script) is provided to deploy the installer on a network: `glpi-agent-deployment.vbs <https://raw.github.com/glpi-project/glpi-agent/develop/contrib/windows/glpi-agent-deployment.vbs>`_.

MacOS
-----

The installer integrates its native, although reduced but recent, version of `Perl <https://www.perl.org/>`_ including recent `OpenSSL support <https://www.openssl.org/>`_.

Get the latest ``.pkg`` package from `our releases page <https://github.com/glpi-project/glpi-agent/releases>`_ or the `nightly build page <https://nightly.glpi-project.org/glpi-agent>`_. After installing it, you'll have to configure the agent to your needs by creating a dedicated ``.cfg`` file under the ``/Applications/GLPI-Agent.app/etc/conf.d`` folder.

You can for example create a ``local.cfg`` file and :

* add the ``server = GLPI_URL`` line to point to your GLPI server,
* eventually set ``debug = 1`` to generate some debug in logs,
* set a ``tag`` like ``tag = MyLovelyTag``.

GNU/Linux
---------

We support major distros as we provides generic packages for **RPM** and **DEB** based distros as well if they supports **Snap** packaging. You can install required packages after getting them from `our github releases page <https://github.com/glpi-project/glpi-agent/releases>`_ or the `nightly build page <https://nightly.glpi-project.org/glpi-agent>`_.

Snap
^^^^

The `Snapcraft`_ **Snap** package integrates its native, although reduced but recent, version of `Perl <https://www.perl.org/>`_ including recent `OpenSSL support <https://www.openssl.org/>`_.

If your system support **Snap**, you can simply install the agent with the ``snap`` command after getting the **Snap** package from `our releases page <https://github.com/glpi-project/glpi-agent/releases>`_ or the `nightly build page <https://nightly.glpi-project.org/glpi-agent>`_. Then, you just have to run:

.. prompt:: bash
   :substitutions:

   snap install --classic --dangerous GLPI-Agent-|version|_amd64.snap

After installation, you can easily configure the agent with the **set** ``snap`` sub-command:

.. prompt:: bash

   snap set glpi-agent server=http://myserver/front/inventory.php

Any supported glpi-agent option can be set this way. If you need to unset a configuration parameter, just set it empty:

.. prompt:: bash

   snap set glpi-agent tag=

.. note::

   You won't find the package in the `Snapcraft`_ store as the agent features and requirements can't apply to their standard policies.

.. _Snapcraft: https://snapcraft.io/

Linux Installer
^^^^^^^^^^^^^^^

.. note::

   The only requirement for the linux installer is to have the ``perl`` command available.

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

GLPI agent come with a test-suite. You can run it with this command:

.. prompt:: bash

   make test

PERL Dependencies
^^^^^^^^^^^^^^^^^

The easiest way to install perl dependencies is to use `cpanminus <http://cpanmin.us>`_ script, running:

.. prompt:: bash

   cpanm .

You can use the ``--notest`` flag if you are brave and want to skip the tests suite execution for each install perl module.

Offline installations
*********************

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
