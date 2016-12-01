## Installing and Running NexentaEdge Scale-Out NFS v3/v4/v4.1 compatible service container
This guide will explain how to setup Scale-Out NFS service container on one or more servers. Assumption is that cluster is alredy setup and functional.

### Step 1: Setting up Replicast network
NexentaEdge design for high performance and massive scalability beyound 1000 servers per cluster. It doesn't have central metadata server or coordination server. Its design is shared nothing with metadata and data fully distributed across the cluster. To work optimally NexentaEdge requires dedicated backend high-performance network, isolated with VLAN segment and set for Jumbo Frames.

Follow guide lines from installation guide with regards of setting up [Replicast network](https://github.com/Nexenta/edge-dev/blob/master/INSTALL.md#step-1-setting-up-replicast-network).

### Step 2: Prepare local host configuration for Data Container
There are example configuration files (see conf directory) to modify. Adjust networking interface in accordance with Replicast networking configuration.

* edit [nesetup.json](https://github.com/Nexenta/nedge-dev/blob/master/conf/gateway/nesetup.json) - [download](https://raw.githubusercontent.com/Nexenta/nedge-dev/master/conf/gateway/nesetup.json) from "gateway" profile (located in conf directory) and copy it over to some dedicated container directory, e.g. /root/c0

### Step 3: Create service configuration
Use NEADM management tool to setup service parameters, at the minimum execute this command below so that it will create service with name "nfs-revenue":
```
neadm service create nfs nfs-revenue
```

### Step 4: Run NexentaEdge GW NFS service across cluster
There is no limits on how many GW containers can existing within Replicast network. Start the NexentaEdge service container with the following run command:
```
mkdir -p /root/c0/var
mount --make-shared /
docker run --ipc host --network host --name nedge-nfs-revenue \
	-e CCOW_SVCNAME=nfs-revenue \
	-e HOST_HOSTNAME=$(hostname) -d -t -i --privileged=true \
	-v /root/c0/var:/opt/nedge/var \
	-v /root/c0/nesetup.json:/opt/nedge/etc/ccow/nesetup.json:ro \
	-v /dev:/dev \
	-v /var/lib/ndnfs:/var/lib/ndnfs:shared \
	-v /run/docker/plugins:/run/docker/plugins \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v /etc/localtime:/etc/localtime:ro \
        nexenta/nedge /opt/nedge/nmf/nefcmd.sh start -j nfsserv
```

At this point you will have NFS service running. Add SERVERID (can be found with command "neadm system status") to the service:
```
neadm service add nfs-revenue SERVERID
```

Create couple of buckets to share via NFS:
```
neadm bucket create company-branch1/finance/revenue
neadm bucket create company-branch1/finance/statistics
```

Share buckets:
```
neadm nfs share company-branch1/finance/revenue
neadm nfs share company-branch1/finance/statistics
```

Now we have two buckets exported, mountable via NFS protocols.

### Step 5: Verify that service is running

TODO

### Step 6: Verify that volume is functional with Docker ndnfs volume driver
Create new volume myvol1. Volume will be created and you should be able to inspect it:

```
neadm bucket create company-branch1/finance/salary
docker volume create -d ndvol --name myvol1 -o size=16G -o bucket=company-branch1/finance/salary
docker volume inspect myvol1
[
    {
        "Name": "myvol1",
        "Driver": "ndnfs",
        "Mountpoint": "/var/lib/ndnfs/myvol1",
        "Labels": {},
        "Scope": "local"
    }
]
```

Corresponding new NFS share will be created. List it using "neadm nfs list" command.

Start some container and attach volume to it, you will see that volume will be automatically mounted:
```
docker run -v myvol1:/tmp -dit alpine /bin/sh
```

Stop/Remove "alpine" container and you should see that volume is automatically unmounted
