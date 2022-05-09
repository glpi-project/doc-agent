Proxy Server Plugin
===================

The purpose of this plugin is to enable a proxy mode on the embedded HTTP interface.

.. mermaid::
   :caption: Proxy Server Plugin diagram

   sequenceDiagram
      participant A as Isolated GLPI Agents
      participant B as GLPI Proxy Agent
      participant C as GLPI Server
      activate B
      Note over B: Proxy Server Plugin enabled
      rect rgb(41, 128, 185)
      Note left of B: Isolated network
      activate A
      Note over A: Inventory task
      A->>B: Submit Inventory
      deactivate A
      end
      rect rgb(0, 163, 245)
      Note right of B: Intranet
      B->>C: Transmit Inventory
      activate C
      C->>B: OK
      deactivate C
      end
      B->>A: OK
      Note over C: Inventory integrated in GLPI
      deactivate B

It can replace a proxy pass configuration on a http server or a complex proxy setup.
It offers few other advantages and features that can be used in advanced setup.

Setup
*****

By default, this plugin is disabled. The first step is to enable it creating a dedicated configuration:

#. Locate the ``proxy-server-plugin.cfg`` file under the GLPI agent :ref:`configuration folder <system-location>` [#f1]_,
#. Make a copy of this file in the same folder by just changing the file extension from ``.cfg`` to ``.local``.
#. Edit the ``proxy-server-plugin.local`` and set ``disabled`` to ``no``

This way, the agent will start to accept inventory submission on its current port and on ``/proxy/glpi`` as base url.
If a GLPI server is setup, any submitted inventory will be forwarded to that GLPI server.

.. note::

   You can also enable a **secondary proxy** by creating the ``proxy2-server-plugin.local`` configuration.
   The purpose here is to enable another proxy configuration on the same agent, mostly in the case
   you need it on a dedicated port with eventually SSL support plugin enabled.

Configuration
*************

The default configuration is self-explanatory:

::

   # By default, a plugin is always disabled unless "disabled" is set to "no" or "0".
   # You can uncomment the following line or set it in included configuration file
   # at the end of this configuration
   #disabled = no

   # Set base url matching for API
   #url_path = /proxy
   # Note: the server URL to set on client would have to be http[s]://[host]:[port][url_path]/glpi
   # By default, this should be: http://[agent-ip-or-dns]:62354/proxy/glpi

   # Port on which to listen for inventory requests, default to legacy port
   #port = 62354

   # The delay the proxy should return as contact timeout to agents (in hours)
   #prolog_freq = 24

   # Option to handle proxy local storing. Set a folder full path as local_store to
   # also store received XML locally. Set only_local_store to not immediatly send
   # received XML to known server(s).
   #only_local_store = no
   #local_store = 

   # To limit any abuse we expect a maximum of 30 requests by hour and by ip (3600 seconds)
   # You can adjust the rate limitation by updating the requests number limit
   # or the period on which apply the requests number limit
   #maxrate        = 30
   #maxrate_period = 3600

   # The maximum number of forked handled request
   #max_proxy_threads = 10

   # The maximum number of proxy a request can pass-through
   #max_pass_through = 5

   # By default, if a GLPI server is set, we consider it supports GLPI protocol
   # otherwise this proxy should only support legacy XML based protocol
   #glpi_protocol = yes

   # no-category config returned to agent when using CONTACT protocol without GLPI server
   # or if only_local_store is set to yes
   # no_category =
   # Example: no_category = process,environment

   # You should create and define you specific parameter in the following
   # included configuration file to override any default.
   # For example just set "disabled = no" in it to enable the plugin
   include "proxy-server-plugin.local"

``disabled``
   Can be set to "no" to enable the plugin. (By default: yes)

``port``
   Can be set to a port on which the agent will listen too. (By default: 0, meaning use agent port)

   You can dedicate a port for the proxy usage. You can even enable the :doc:`ssl-server-plugin`, and
   set the port in its ``ports`` list to force using SSL with the proxy mode.

``prolog_freq``
   In the case the proxy agent is not in touch with a GLPI server, this is the delay
   time in hours an inventory should be sent by contacting agents. (By default: 24)

``only_local_store``
   Set to ``yes`` to only store locally submitted inventories. (By default: no)

   This can be handy if the only purpose is to collect inventories and no GLPI server
   is reachable. Stored inventories could then be passed later to ``glpi-injector``.

``local_store``
   This is a full path where to store submitted inventories. If set, the proxy agent will
   always stored submitted inventories. (By default: empty)

   You must manage by yourself the stored inventories or you may face a storage outage
   after a while if many agents submits inventories. But as inventories are stored
   with the deviceid as file basename, new inventory for a known agent will just
   replace the existing one.

   This storage may be used as an inventory backup solution but keep in mind this
   storage should be keep secured as it will contains a lot of sensible datas.


``maxrate`` and ``maxrate_period``
   Limit requests for a given ip to **maxrate** other the **maxrate_period** time (in seconds).
   (By default: **30** requests by **3600** seconds for a single ip)

   This 2 parameters could be used to limit abuse if the agent proxy if listening on a public network.

   By default the average request for a given ip should be lower than 2. But this can be
   greater if the other ip is a chained proxy. In that last case, you may need to grow that values.

``max_proxy_threads``
   This set the maximum number of single requests the proxy agent can handle at the same time. (By default: 10)

.. _max_pass_through:

``max_pass_through``
   This set the maximum number of proxy agents a single inventory submission can pass. (By default: 5)

   Each time a inventory is submitted, a HTTP header value is set or increased. If that value reachs
   the ``max_pass_through`` of a proxy agent, the inventory won't be submitted to the next proxy agent.

   Changing this parameter is only needed when you're using a chained proxy agents configuration
   and when you have at least 5 proxy agents in the chain. This parameter is a security to
   block loops in the case of chained proxy agents misconfiguration pointing to each others.

``glpi_protocol``
   Set to "no" if you don't want to use new GLPI Agent Protocol needed for GLPI native inventory. (By default: yes)

   When set to "no", the proxy agent will just act as a legacy GLPI server supporting XML inventory format only.
   Otherwise, it will tell remote agent to use new protocol which involves to send inventory in JSON format.

``no_category``
   This is a comma separated list of category to not include in inventories. It has the same purpose
   than :ref:`no-category configuration <no-category>` but set on server-side. This only works
   with new GLPI Agent Protocol and JSON format.

Use cases
*********

Private network inventory storage
"""""""""""""""""""""""""""""""""

In the case, you have a private network from where no device can access the GLPI server, you can:

.. mermaid::

   sequenceDiagram
      participant A as Isolated GLPI Agents
      participant B as GLPI Proxy Agent
      actor C as Human or secured transport
      participant D as GLPI Server
      activate B
      Note over B: Proxy Server Plugin enabled
      rect rgb(41, 128, 185)
      Note over A,B: Isolated network
      activate A
      Note over A: Inventory task
      A->>B: Submit Inventory
      B->>A: OK
      deactivate A
      deactivate B
      Note over B: Inventory stored on Proxy system
      end
      B->>C: Copy Inventory
      rect rgb(0, 163, 245)
      Note over C,D: Intranet
      C->>D: Inject Inventory
      activate D
      D->>C: OK
      deactivate D
      end
      Note over D: Inventory integrated in GLPI

First, store submitted inventory using a proxy agent with such ``proxy-server-plugin.local`` configuration::

   disabled = no
   only_local_store = yes
   local_store = /var/glpi-agent/proxy

Then, from GLPI server or a dedicated platform with GLPI server access possible, get a copy of stored inventories into a dedicated folder:

* using a command like ``scp``, ``ftp`` or ``rsync``

* using an USB key

Finally, inject inventories into GLPI with ``glpi-injector`` script:

.. prompt:: bash

   glpi-injector -d /var/glpi-agent -r -R -u http://my-glpi-server/

Proxy with HTTP and HTTPS support
"""""""""""""""""""""""""""""""""

In the case you need to secure a private network with eventually old FusionInventory agent not supporting SSL,
but you still need SSL for newer GLPI Agents, you can create a proxy agent listening on port 80 and port 443.

First, enable main proxy mode on port 443 with the following ``proxy-server-plugin.local`` configuration::

   disabled = no
   port = 443

Secondly, enable the secondary proxy mode on port 80 with the following ``proxy2-server-plugin.local`` configuration::

   disabled = no
   port = 80

Also enable the :doc:`ssl-server-plugin` with the following ``ssl-server-plugin.local`` configuration::

   disabled = no
   ports = 443

Now, in agent configuration having access to the proxy agent, you can use any one of the 2 following URL as :ref:`server configuration<server>`::

   server = http://proxy-agent/proxy/glpi
   server = https://proxy-agent/proxy/glpi

Here you don't have to specify the port as standard http and https ports are used. The only requirement for the proxy agent
is to run on a dedicated server with that ports not used by any other service.

Chained proxies
"""""""""""""""

Imagine you want to inventory the devices from one factory of your company in a given town having its dedicated and private network.
This factory network is only visible via a vpn at the town level through a network being able to see other factories in the same town.
Now your GLPI server is located in your head quarter in another town linked through a dedicated network link.

You can first create a proxy agent at the factory level just by enabling the proxy plugin on one computer, let'say the one with ``10.77.200.55`` ip.
You just need to enable the plugin with the following ``proxy-server-plugin.local`` configuration::

   disabled = no

Do the same on other agent where you need the plugin, the one at the town level, let's say it has the ``10.77.0.2`` ip.
And do also the same with the agent in the head quarter network with let's say the ``10.1.0.120`` ip.

On all other devices in the factory, setup agents with the following URL as :ref:`server configuration<server>`::

   server = http://10.77.200.55:62354/proxy/glpi

On the agent with the proxy plugin enabled, set the server URL to the proxy agent enabled at the town level::

   server = http://10.77.0.2:62354/proxy/glpi

On the agent at the town level with the proxy plugin enabled, set the server URL to the proxy agent enabled at the head quarter level::

   server = http://10.1.0.120:62354/proxy/glpi

On the agent at the head quarter level, just set the normal GLPI server URL as :ref:`server configuration<server>`.

Then you just have to secure your network to permit each proxy agent to communicate on port 62354 with its chained one.

.. note::

   Remember only 5 proxy agents can be chained by default (see :ref:`max_pass_through parameter <max_pass_through>`).
   If you want to chain more proxy agents, set this parameter value to a higher value starting from the 6th proxy agent.

.. rubric:: Footnotes

.. [#f1] on windows the configuration is also a file under the ``etc`` sub-folder of the
   GLPI Agent installation folder.
