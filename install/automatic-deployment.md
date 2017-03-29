## Fully Automatic deployment of NexentaEdge Container-Converged environment
This procedure describes mechanism to deploy Storage and Networking infrastructure for Docker Containers for production usage. Deployment tool pre-checking environment and ensures that destination targets meets all the requirements. It also sets most optimal configuration and provides a way to select profile whie deploying.

### Step 1: Designing cluster network

From a physical perspective, a NexentaEdge cluster is a collection of server devices connected via a high-performance 10,25,40,etc Gigabit switch. From a logical perspective, a NexentaEdge cluster consists of data nodes and gateway nodes running as containers that communicate over a Replicast network. The cluster provides storage services over an external network using the protocols that NexentaEdge supports. A NexentaEdge deployment consists of a single physical cluster and one or more logical cluster namespaces. Each logical cluster namespace may have multiple different tenants.

Figure below shows the components of a NexentaEdge cluster:

![fig1: deplyoment](https://raw.githubusercontent.com/nexenta/nedge-dev/master/images/deployment.png)

A NexentaEdge cluster consists of the following components. A given device may have multiple roles assigned to it; for example, a server may be configured as a data node, gateway node and management controller.

* Data node containers - The data nodes collectively provide the storage for the NexentaEdge cluster. Objects are broken into chunks and distributed across the data nodes using the Replicast protocol. The set of data nodes where the chunks are stored or retrieved is determined based on server load and capacity information. Data nodes may be configured with interfaces to an IPv6 Replicast network for data distribution and storage and to an IPv4 network (either an external network or dedicated management network) for initial configuration with the NEDEPLOY tool and subsequent administration with the NEADM tool. After initial configuration, data nodes require only a connection to the Replicast network, since administration of the data nodes is done by the deployment workstation via the management controller node, which has connectivity to both the management network and the Replicast network.

* Gateway node containers - Gateway nodes provide the connection between external clients and the data stored in the NexentaEdge cluster. Gateway nodes accept and respond to client requests, translating them into actions performed in the NexentaEdge cluster. Gateway nodes are provisioned with interfaces to the external network, Replicast network, and management network (if different from the external network). When you configure a NexentaEdge cluster, you indicate which storage service(s) you want to provide for a given tenant, then specify which should be the gateway nodes for that cluster/tenant/service combination.

* Replicast network - The Replicast network is an isolated IPv6 VLAN used for communication and data transfer among the data nodes and gateway nodes in the NexentaEdge cluster. The Replicast protocol provides the means for efficient storage and retrieval of data in the cluster.

* Deployment workstation container - The deployment workstation is the system from which you deploy and configure the NexentaEdge software to the other nodes. NexentaEdge uses the Chef environment for installation. You deploy NexentaEdge using a Chef Solo instance packaged with the NexentaEdge software.  To deploy NexentaEdge to the nodes in the cluster using the NEDEPLOY tool, the deployment workstation must have IPv4 network connectivity to the nodes, either through a management network or an external network.

* Management controller node - A management controller (typically co-resident with Data or Gateway container) is a node that translates external cluster-wide behavior into internal component-specific configuration, and may provide the connection between the deployment workstation and the data nodes in the Replicast network. At least one of the nodes in the cluster must be a management controller. Management controllers need to have network connectivity to both the deployment workstation and to the other nodes in the cluster.

* External network - External clients store and retrieve data in the NexentaEdge cluster by communicating with gateway nodes on the external network. The external network may use IPv4 or IPv6 and is likely to carry traffic unrelated to NexentaEdge.

* Management network - To aid in deploying and administering the NexentaEdge cluster, you may elect to place the deployment workstation and data nodes in a dedicated IPv4 management network. The NEDEPLOY and NEADM tools, running on the deployment workstation, send configuration information to and receive status information from the data nodes over this network.

* External clients - External clients are end-user application containers that access data stored in the NexentaEdge cluster via gateway nodes. External clients access data in the cluster using APIs of the storage services NexentaEdge supports: Docker volumes (NBD, NFS), Direct NFSv3,v4,v4.1, Block iSCSI/HA, Swift/S3/S3S Object.

### Step 2: Install NEDEPLOY and NEADM management tools
NexentaEdge defines set of well described Chef Cookbooks which provides easy way to deploy complex cluster infrastructure excluding possible human error.

To enable NEDEPLOY tool set the following or similar alias:
```
alias nedeploy="docker run --network host -it nexenta/nedge-nedeploy /opt/nedeploy/nedeploy"
```

Get familiar with the tool and run the pre-check utility to ensure that the node(s) meets the requirements for being added to the cluster:

```
nedeploy precheck <ip-address> <username:password> -i <interface>
   [-t <profile>][-x <disks-to-exclude>][-X <disks-to-reserve>]
```

To enable NEADM tool setup the following or similar alias:

```
alias neadm="docker run -i -t --rm -v ~/.neadmrc:/opt/neadm/.neadmrc --network host nexenta/nedge-neadm /opt/neadm/neadm"
```

Copy [.neadmrc](https://github.com/Nexenta/nedge-dev/blob/master/conf/default/.neadmrc) - [download](https://raw.githubusercontent.com/Nexenta/nedge-dev/master/conf/default/.neadmrc) from "default" profile (located in conf directory) to ~/. If you planning to use neadm tool on a different host, you'll need to adjust API_URL to point to the right management IPv4 address. Default management port is 8080.

Optionally source [.bash_completion](https://github.com/Nexenta/nedge-dev/blob/master/conf/default/.bash_completion) - [download](https://raw.githubusercontent.com/Nexenta/nedge-dev/master/conf/default/.bash_completion) from "default" profile (located in conf directory).

See "Prerequisites" section in [Installation Guide](https://nexenta.com/sites/default/files/docs/ReleaseNotes/NEdge-1.1.0-FP3-IG_20160629.pdf)

### Step 3: Selecting most optimal operational profile and provision your cluster

From the NexentaEdge deployment workstation, use the following command to deploy the NexentaEdge software to the nodes:

```
nedeploy deploy solo <ip-address> <nodename> <username:password> -i <interface>
    [-t <profile>][-x <disks-to-exclude>][-X <disks-to-reserve>][-z <zone>][-F <filesytem-type>][-m]
    [--docker][--P <number-of-partitions>][--upgrade]
```

Ensure that option "--docker" is specified, so that it will automatically provision ready to use OpenvSwitch-based networking infrastructure and preset Gateway container images.

Consult with "Installing NexentaEdge" section in [Installation Guide](https://nexenta.com/sites/default/files/docs/ReleaseNotes/NEdge-1.1.0-FP3-IG_20160629.pdf)

Verify that cluster gets installed and nodes appearing in NEADM output. From the NexentaEdge management workstation, use the following command to see the status of installing cluster:

```
neadm system status
```

### Step 4: Deploying management GUI

To simplify infrastructure management and get familiarity with the solution quicker, please deploy management GUI. On the NexentaEdge management workstation, use the following command to deploy the NexentaEdge GUI software:

```
docker run -d -P -p 3000:3000 -e API_ENDPOINT=%ADDR% nexenta/nedgeui:2.0.0
```

Replace %ADDR% with http://IP:PORT pointing to management endpoint. Example: http://192.168.1.1:8080.

Using compatible browser (certified with Firefox and Chrome), login to the URL exposed on NexentaEdge management workstation running GUI docker image.

Consult with "Starting the NexentaEdge GUI" section in [Installation Guide](https://nexenta.com/sites/default/files/docs/ReleaseNotes/NEdge-1.1.0-FP3-IG_20160629.pdf)
