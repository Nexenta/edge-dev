## Installing and Running NexentaEdge S3/S3s Object service container
This guide will explain how to setup s3 Object service container on one or more servers. Assumption is that cluster is alredy setup and functional.

### Step 1: Setting up Replicast network
NexentaEdge design for high performance and massive scalability beyound 1000 servers per cluster. It doesn't have central metadata server or coordination server. Its design is shared nothing with metadata and data fully distributed across the cluster. To work optimally NexentaEdge requires dedicated backend high-performance network, isolated with VLAN segment and set for Jumbo Frames.

Follow guide lines from installation guide with regards of setting up [Replicast network](https://github.com/Nexenta/edge-dev/blob/master/INSTALL.md#step-1-setting-up-replicast-network).

### Step 2: Prepare local host configuration for Data Container
There are example configuration files (see conf directory) to modify. Adjust networking interface in accordance with Replicast networking configuration.

* edit [nesetup.json](https://github.com/Nexenta/nedge-dev/blob/master/conf/gateway/nesetup.json) - [download](https://raw.githubusercontent.com/Nexenta/nedge-dev/master/conf/gateway/nesetup.json) from "gateway" profile (located in conf directory) and copy it over to some dedicated container directory, e.g. /root/c0

### Step 3: Create service configuration
Use NEADM management tool to setup service parameters
```
neadm service create s3 s3finance
neadm service serve company-branch1/finance
```

### Step 4: Run NexentaEdge GW S3 Object service across cluster
There is no limits on how many s3 GW containers can existing within Replicast network. Start the NexentaEdge service container with the following run command:
```
mkdir -p /root/c0/var
docker run --ipc host --network host --name nedge-s3finance \
	-e CCOW_SVCNAME=s3finance \
	-e HOST_HOSTNAME=$(hostname) -d -t -i --privileged=true \
	-v /root/c0/var:/opt/nedge/var \
	-v /root/c0/nesetup.json:/opt/nedge/etc/ccow/nesetup.json:ro \
	-v /dev:/dev \
	-v /etc/localtime:/etc/localtime:ro \
        nexenta/nedge /opt/nedge/nmf/nefcmd.sh start -j ccowgws3
```
Substitute ccowgws3 with ccowgws3s to serve S3 where buckets accessible as subdomain names, e.g. mybucket1.company.com rather then s3.company.com/mybucket1

At this point you will have S3 Object service running.

### Step 5: Verify that service is running
```
curl http://localhost:9982/
```
