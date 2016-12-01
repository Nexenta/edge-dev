## Installing and Running NexentaEdge SWIFT Object service container
This guide will explain how to setup SWIFT Object service container on one or more servers. Assumption is that cluster is alredy setup and functional.

### Step 1: Setting up Replicast network
NexentaEdge design for high performance and massive scalability beyound 1000 servers per cluster. It doesn't have central metadata server or coordination server. Its design is shared nothing with metadata and data fully distributed across the cluster. To work optimally NexentaEdge requires dedicated backend high-performance network, isolated with VLAN segment and set for Jumbo Frames.

Follow guide lines from installation guide with regards of setting up [Replicast network](https://github.com/Nexenta/edge-dev/blob/master/INSTALL.md#step-1-setting-up-replicast-network).

### Step 2: Prepare local host configuration
There are example configuration files (see conf directory) to modify. Adjust networking interface in accordance with Replicast networking configuration.

* edit [nesetup.json](https://github.com/Nexenta/nedge-dev/blob/master/conf/gateway/nesetup.json) - [download](https://raw.githubusercontent.com/Nexenta/nedge-dev/master/conf/gateway/nesetup.json) from "gateway" profile (located in conf directory) and copy it over to some dedicated container directory, e.g. /root/c0

### Step 3: Create service configuration
Use NEADM management tool to setup service parameters
```
neadm service create swift swiftsvc1
neadm service serve company-branch1
```

### Step 4: Run NexentaEdge GW SWIFT Object service across cluster
There is no limits on how many SWIFT GW containers can existing within Replicast network. Start the NexentaEdge service container with the following run command:
```
mkdir /root/c0/var
docker run --ipc host --network host --name nedge-swift \
	-e CCOW_SVCNAME=swiftsvc1 \
	-e HOST_HOSTNAME=$(hostname) -d -t -i --privileged=true \
	-v /root/c0/var:/opt/nedge/var \
	-v /root/c0/nesetup.json:/opt/nedge/etc/ccow/nesetup.json:ro \
	-v /dev:/dev \
	-v /etc/localtime:/etc/localtime:ro \
        nexenta/nedge /opt/nedge/nmf/nefcmd.sh start -j ccowgw
```

At this point you will have SWIFT Object service running.

### Step 6: Verify that service is running
```
curl http://localhost:9981/v1/finance
```
