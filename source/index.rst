
GLPI Agent documentation
========================

Welcome to the GLPI Agent Documentations, your comprehensive guide to understanding, installing, configuring, and effectively managing the GLPI Agent.
As an integral component within the GLPI Inventory ecosystem, the GLPI Agent plays an important role in simplifying inventory tracking, management and unify asset management processes.

The GLPI Agent is a tool developed and designed to address complex challenges associated with IT asset management. It makes the collection and transmission of critical data from connected devices to the central GLPI Server, ensuring that administrators and IT professionals can maintain a real-time hardware and software photograph of the company or clients.
With this information, organizations can make decisions based in real data, reduce downtime, optimize resource allocation, enhance security protocols, plan new purchases and be in compliance with licensing, and security requirements.

This documentation is directed to a diverse audience. It can include system administrators, IT professionals, network engineers, and anyone responsible for tasks of asset and inventory management within the organization. Whether you are an experienced IT specialist looking to harness the full potential of GLPI Agent or a beginner seeking to understand its functionalities, this guide is designed to meet your needs.

This documentation provides a comprehensive coverage of the GLPI Agent, including the full scope of tasks involved in its deployment and management. This embraces step-by-step instructions on installation, detailed insights and hints into configuration settings, practical guidance on usage, and a robust troubleshooting section to help you find and fix common issues. We believe that empowering administrator with the knowledge and tools required to maximize the benefits of the GLPI Agent is the best way to ensure a seamless and efficient asset management experience. 

Compatibility and main purpose
------------------------------

GLPI Agent is the successor of `FusionInventory Agent <https://github.com/fusioninventory/fusioninventory-agent>`_, since it's based on the same code and it can be easily used in place of any FusionInventory agent.

- It is used to run automatic inventory and works with `GLPI ITSM software tool <https://glpi-project.org/>`_.
- It also supports running few other tasks like package deployment, information collect, network devices discovery and inventory, ESX remote inventory.
- It also supports agentless inventory through its remoteinventory task.
- It was developed to allow you to automatically run tasks that can currently only be run manually or using glpi-inventory plugin.
- On server-side, it only depends on GLPI starting from GLPI 10 version.

.. attention::
   For older GLPI version (9.5 or below), it also depends on `FusionInventory for GLPI plugin <https://github.com/fusioninventory/fusioninventory-for-glpi>`_.


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

