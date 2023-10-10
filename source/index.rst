
GLPI Agent documentation
========================

GLPI Agent is essentially a program used to run automatic inventory and works with `GLPI ITSM software tool <https://glpi-project.org/>`_.
It also supports running few other tasks like package deployment, information collect, network devices discovery and inventory, ESX remote inventory.
It also supports agentless inventory through its remoteinventory task.
It was developed to allow you to run tasks that can currently only be run manually or using glpi-inventory plugin.

GLPI Agent is the successor of `FusionInventory Agent <https://github.com/fusioninventory/fusioninventory-agent>`_.
It is based on the same code and it can be easily used in place of FusionInventory.
On server-side, it only depends on GLPI starting from GLPI 10 version.
For older GLPI version, it also depends on `FusionInventory for GLPI plugin <https://github.com/fusioninventory/fusioninventory-for-glpi>`_.

.. toctree::
   :maxdepth: 5
   :includehidden:

   installation/index
   configuration
   usage
   tasks/index
   plugins/index
   IDS databases <database>
   bug-reporting
   man/index

Documentation license
---------------------

This documentation is distributed under the terms of the `Creative Commons License Attribution-ShareAlike 4.0 (CC BY-SA 4.0) <https://creativecommons.org/licenses/by-sa/4.0/>`_.

For the complete terms of the license, please refer to https://creativecommons.org/licenses/by-sa/4.0/legalcode.

You are free to:

* Share — copy and redistribute the material in any medium or format
* Adapt — remix, transform, and build upon the material for any purpose, even commercially.

The licensor cannot revoke these freedoms as long as you follow the license terms.

Under the following terms:

* Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
* ShareAlike — If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.

No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

