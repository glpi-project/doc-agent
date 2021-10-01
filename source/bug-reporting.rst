Bug reporting
=============

.. attention:: Problems related to this documentation should be reported on `its dedicated project issue tracker <https://github.com/glpi-project/doc-agent/issues>`_.
   You can also just edit the project in your own github environment and `submit a pull request <https://github.com/glpi-project/doc-agent/pulls>`_.

For any GLPI agent problem or issue, you need to use `GitHub issue tracker <https://github.com/glpi-project/glpi-agent/issues>`_,
and report your issue with all the requested informations. This requires an GitHub user account.

.. hint:: Before reporting your problem, always take a look at the `opened and closed GitHub issues <https://github.com/glpi-project/glpi-agent/issues?q=is%3Aissue+is%3Aopen+is%3Aclosed>`_
   by updating the `Filters` field and check if your problem has still not been addressed.

Problem description
-------------------

You have to use english, for the sake of internationalization.

Always describe your problem clearly and precisely, for someone without any prior knowledge of your environment.

To do so, always describe:

 - the operating system on which the GLPI agent is running,
 - the GLPI agent version you're using and the way you installed it,
 - the problem itself, eventually including log extract or agent run output,
 - what you're expecting

.. hint:: You can obtain a more verbose output when running the agent from the console by using ``--debug`` option to set debug level 1,
   or by using ``--debug --debug`` options to set debug level 2. You can also set the :ref:`debug parameter <debug>` in configuration to ``1`` or ``2``
   and restart the daemon or service.

External data
-------------

When the issue is related to some missing or invalid value, it can be caused by a parsing error while processing external data (a command output, a file, whatever...).
In order to reproduce the problem and find a way to fix it, we need a sample of those data.

You can then attach the relevant file or command output as an attachement to the issue report.
If there is any privacy concern, try to obfuscate sensible data or ask for an email where to send it.

On unix/linux, when running any command for such purpose, you always must unset locales first to avoid localized output:

.. prompt:: bash

   export LC_ALL=C

Here are other command-specific advices:

WMI queries
"""""""""""

Windows WMI queries can be exported with ``wmic`` tool:

.. prompt:: batch

   wmic path <somequery> get /Format:list > <somefile.txt>

Registry extract
""""""""""""""""

Windows registry content can be exported with ``regedit`` tool:

.. prompt:: batch

   regedit /e <somefile.reg> <somekey>

dmidedoce output
""""""""""""""""

``dmidecode`` output can be generated on any system, including windows, as we ship a ``dmidecode`` executable in the agent windows packaging, under the ``perl\bin`` subdirectory.

.. prompt:: batch

   "C:\Program Files\GLPI-Agent\glpi-agent\perl\bin\dmidecode" > dmidecode-output.txt

On unix/linux, just run the command in a ``root`` console:

.. prompt:: bash

   dmidecode >dmidecode-output.txt

snmpwalk output
"""""""""""""""

Snmpwalk output can be generated with the following command under unix/linux:

.. prompt:: bash

   snmpwalk -v <version> -c <community> -t 15 -Cc -On -Ox <somehost> .1 > walk-filename.walk

Using an explicit root OID (.1 here), a non-default timeout (``15`` seconds, the same one as the agent default), and disabling internal consistency checks (``-Cc``) are required to extract all possible data.

Option ``-Ox`` is not mandatory but can help to enhance debugging discovery and inventory tasks as we may not know anything about the related MIB. So just having full numeric values can help.

Option ``-On`` is required to keep OID numerically to be sure to have a fully compliant snmp walk.

.. hint:: Joining known private MIBs related to your device could be really useful. You always can share them privately if you don't have the right to make them public.

.. hint:: When reporting a snmp walk, list all possible expected data you can know by another way, and at least the missing ones, like:

      * serial number
      * accurate model name
      * manufacturer
      * device name
      * device mac address
      * ...
