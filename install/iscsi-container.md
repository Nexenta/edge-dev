## Installing and Running NexentaEdge Scale-Out Shared NameSpace iSCSI protocol compatible service container

### Step 1: Setting up Replicast network
NexentaEdge design for high performance and massive scalability beyound 1000 servers per cluster. It doesn't have central metadata server or coordination server. Its design is shared nothing with metadata and data fully distributed across the cluster. To work optimally NexentaEdge requires dedicated backend high-performance network, isolated with VLAN segment and set for Jumbo Frames.

Follow guide lines from from Data Container with regards of setting up Replicast network.

### Step 2: Prepare local host configuration for Data Container
There are example configuration files (see conf directory) to modify. Adjust networking interface. Typicaly first port assigned will be eth0.

* edit [nesetup.json](https://github.com/Nexenta/nedge-dev/blob/master/conf/gateway/nesetup.json) - [download](https://raw.githubusercontent.com/Nexenta/nedge-dev/master/conf/gateway/nesetup.json) from "gateway" profile (located in conf directory) and copy it over to some dedicated container directory, e.g. /root/c0

### Step 3: Create service configuration
Use NEADM management tool to setup service parameters
```
neadm service create iscsi iscsi-mongodb
neadm service serve company-branch1/finance/databases/mongodb
```

### Step 4: Run NexentaEdge GW iSCSI scale-out block service across cluster
There is no limits on how many GW containers can existing within Replicast network. Start the NexentaEdge service container with the following run command:
```
docker run --ipc host --network host --name nedge-iscsi-mongodb \
	-e CCOW_SVCNAME=iscsi-mongodb \
	-e HOST_HOSTNAME=$(hostname) -d -t -i --privileged=true \
	-v /root/c0/var:/opt/nedge/var \
	-v /root/c0/nesetup.json:/opt/nedge/etc/ccow/nesetup.json:ro \
	-v /dev:/dev \
	-v /etc/localtime:/etc/localtime:ro \
        nexenta/nedge /opt/nedge/nmf/nefcmd.sh start -j iscsiserv
```

At this point you will have iSCSI block service running and exporting LUN to serve MongoDB database

### Step 6: Verify that service is running

TODO
