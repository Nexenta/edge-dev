## Installing and Running NexentaEdge SWIFT Object service container

### Step 1: Setting up Replicast network
NexentaEdge design for high performance and massive scalability beyound 1000 servers per cluster. It doesn't have central metadata server or coordination server. Its design is shared nothing with metadata and data fully distributed across the cluster. To work optimally NexentaEdge requires dedicated backend high-performance network, isolated with VLAN segment and set for Jumbo Frames.

Follow guide lines from from Data Container with regards of setting up Replicast network.

### Step 2: Prepare local host configuration for Data Container
There are example configuration files (see conf directory) to modify. Adjust networking interface. Typicaly first port assigned will be eth0.

### Step 3: Create service configuration
Use NEADM management tool to setup service parameters
```
neadm service create swift swiftsvc1
neadm service serve company-branch1
```

### Step 4: Run NexentaEdge GW SWIFT Object service across cluster
There is no limits on how many GW containers can existing within Replicast network. Start the NexentaEdge service container with the following run command:
```
docker run --network host --name nedge-swift \
	-e CCOW_SVCNAME=swiftsvc1 \
	-e HOST_HOSTNAME=$(hostname) -d -t -i --privileged=true \
	-v /root/gw0/nesetup.json:/opt/nedge/etc/ccow/nesetup.json \
	-v /etc/localtime:/etc/localtime:ro \
	-v /etc/timezone:/etc/timezone:ro \
        nexenta/nedge /opt/nedge/nmf/nefcmd.sh start -j ccowgw
```

At this point you will have SWIFT Object service running.

### Step 6: Verify that service is running
```
curl http://localhost:9981/v1/finance
```
