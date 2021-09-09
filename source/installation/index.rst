Installation
============

The latest release is available either from `our github releases page <https://github.com/glpi-project/glpi-agent/releases>`_ or from `CPAN <https://metacpan.org/release/GLPI-Agent>`_.

Windows
-------

The installer integrates its native, although reduced, version of `Strawberry Perl <http://strawberryperl.com>`_.

You can get the last `GLPI Agent installer for Microsoft Windows <https://github.com/glpi-project/glpi-agent/releases>`_. It is available for both 32 and 64 bits systems and provides a graphical interface as well as command line facilities.

It will perform per default a graphical installation, unless you use the `/S` flag calling it from command line. All installer options are described in :doc:`./windows-command-line`. This manual is also contained in the installer itself; get it using `/help`:

.. code-block:: doscon

   C:\> glpi-agent_windows-<platform>_<version>.exe /help

.. note::

   All graphical installer options are related to a command line one. Check :doc:`./windows-command-line` if you need help.

Large Installations
^^^^^^^^^^^^^^^^^^^

A VBScript (Visual Basic Script) is provided to deploy the installer on a network: `glpi-agent-deployment.vbs <https://raw.github.com/glpi-project/glpi-agent/develop/contrib/windows/glpi-agent-deployment.vbs>`_.

MacOS
-----

First, get the latest ``.pkg.tar.gz`` package from `releases page <https://github.com/glpi-project/glpi-agent/releases>`, and extract it using right click or command line:

.. code-block:: shell

   $ tar xfz glpi-agent_macosx-intel_XXX.pkg.tar.gz

This will extract the `PKG` file. If you want to configure anything, right click on the `PKG` file, and choose `Show the package content`. Go to the resources directory and edit the ``agent.cfg`` file according to your needs.

You can for example:

* add the ``server=`` line,
* uncomment and adapt the ``logfile`` entry to get some logs,
* increase ``backend-collect-timeout``; some of the used commands may take time. We recommend to set at least ``180`` here.

GNU/Linux
---------

You GNU/Linux distribution may provide a native package; you should find it with your usual package manager.

If the Agent is not available; you can still :ref:`install it from sources <install-from-sources>`.

BSD
---

FreeBSD port
^^^^^^^^^^^^

A FreeBSD port is available in ``net-mgmt/p5-GLPI-Agent``.

    cd /usr/ports/net-mgmt/p5-GLPI-Agent/
    make install clean

pkgsrc port
^^^^^^^^^^^

A `pkgsrc port <http://pkgsrc.se/net/p5-GLPI-Agent>`_ is available in ``net/p5-GLPI-Agent``.

.. _install-from-sources:

From sources
------------

.. note::

   We strongly recommend the use of `GNU tar` because some file path length are
   greater than 100 characters. Some tar version will silently ignore those files.

First, you need to extract the source and change the current directory.

.. code-block:: shell

    $ tar xfz GLPI-Agent-1.0.0.tar.gz
    $ cd GLPI-Agent-1.0.0

Executing ``Makefile.PL`` will verify all the required dependencies are available
and prepare the build tree.

.. code-block:: shell

    $ perl Makefile.PL

If you don't want to use the default directory (``/usr/local``), you can use the
``PREFIX`` parameter:

.. code-block:: shell

    $ perl Makefile.PL PREFIX=/opt/glpi-agent

.. note::

   At this point, you may have some missing required modules. See `PERL Dependencies`_
   section for installing them. Once this is done, run the same command again.

You now can finish the installation. Here again we recommend `GNU make` (`gmake`):

.. code-block:: shell

    $ make
    $ make install

Tests
^^^^^

.. note::

   The tests suite requires some additional dependencies like Test::More.

GLPI agent come with a test-suite. You can run it with this command:

.. code-block:: shell

    $ make test

PERL Dependencies
^^^^^^^^^^^^^^^^^

## Perl dependencies

The easiest way to install perl dependencies is to use `cpanminus <http://cpanmin.us>`_ script, running:

.. code-block:: doscon

    $> cpanm .

You can use the ``--notest`` flag if you are brave and want to skip the tests suite execution for each install perl module.

Offline installations
*********************

.. note::

   This requires the cpanminus script to be installed.

First grab the tarball from the website and extract it:

.. code-block:: doscon

    $> tar xzf GLPI-Agent-2.3.19.tar.gz
    $> cd GLPI-Agent-2.3.19

We use ``cpanm`` to fetch and extract the dependencies in the extlib directory:

.. code-block:: doscon

    $> cpanm --pureperl --installdeps -L extlib --notest .

If this command fails with an error related to ``Params::Validate``, then just run
this last command:

.. code-block:: doscon

    $> cpanm --installdeps -L extlib --notest .

Now you can copy the directory to another machine and run the agent this way:

.. code-block:: doscon

    $> perl -Iextlib/lib/perl5 -Ilib glpi-agent

Other dependencies
^^^^^^^^^^^^^^^^^^

On Solaris/SPARC, you must install `sneep <http://www.sun.com/download/products.xml?id=4304155a>`_ and record the Serial Number with it.

On Windows, we use an additional ``dmidecode`` binary shipped in the windows
distribution to retrieve many information not available otherwise, including
fine-grained multi-cores CPUs identification. Unfortunately, this binary is not
reliable enough to be used on Windows 2003, leading to less precise
inventories.

On Linux, ``lspci`` will be used to collect PCI, AGP, PCI-X, ... information.