## Installing and Running NexentaEdge Scale-Out Native Block (NBD) service container

### Step 1: Setting up Replicast network
NexentaEdge design for high performance and massive scalability beyound 1000 servers per cluster. It doesn't have central metadata server or coordination server. Its design is shared nothing with metadata and data fully distributed across the cluster. To work optimally NexentaEdge requires dedicated backend high-performance network, isolated with VLAN segment and set for Jumbo Frames.

Follow guide lines from from Data Container with regards of setting up Replicast network.

### Step 2: Prepare local host configuration for Data Container
There are example configuration files (see conf directory) to modify. Adjust networking interface. Typicaly first port assigned will be eth0.

### Step 3: Prepare serving bucket
Use NEADM management tool to setup service parameters
```
neadm bucket create company-branch1/finance/revenue
```

### Step 4: Run NexentaEdge GW NBD service across cluster
There is no limits on how many GW containers can existing within Replicast network. Start the NexentaEdge service container with the following run command:
```
docker run --ipc host --name nedge-nbd-revenue \
	-e HOST_HOSTNAME=$(hostname) -d -t -i --privileged=true \
	-v /root/c0/nesetup.json:/opt/nedge/etc/ccow/nesetup.json:ro \
	-v /root/c0/sysconfig:/opt/nedge/var/lib/nef/jsondb/sysconfig \
	-v /dev:/dev \
	-v /run/docker/plugins:/run/docker/plugins \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v /etc/localtime:/etc/localtime:ro \
	-v /etc/timezone:/etc/timezone:ro \
        nexenta/nedge /opt/nedge/nmf/nefcmd.sh start -j nbdserv -j rest
```

At this point you will have NBD service running and exporting "ndvol" Docker volume driver.

### Step 5: Verify that volume is functional

```
docker volume create -d ndvol --name myvol1 -o size=16G -o bucket=company-branch1/finance/revenue
docker volume inspect myvol1
```
