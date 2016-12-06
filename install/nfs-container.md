## Installing and Running NexentaEdge Scale-Out NFS v3 compatible service container (EXPERIMENTAL)
This guide will explain how to setup Scale-Out NFS service container on one or more servers. Assumption is that cluster is alredy setup and functional.

### Step 1: Setting up Replicast network
NexentaEdge design for high performance and massive scalability beyound 1000 servers per cluster. It doesn't have central metadata server or coordination server. Its design is shared nothing with metadata and data fully distributed across the cluster. To work optimally NexentaEdge requires dedicated backend high-performance network, isolated with VLAN segment and set for Jumbo Frames.

Follow guide lines from installation guide with regards of setting up [Replicast network](https://github.com/Nexenta/edge-dev/blob/master/INSTALL.md#step-1-setting-up-replicast-network).

### Step 2: Prepare local host configuration for Data Container
There are example configuration files (see conf directory) to modify. Adjust networking interface in accordance with Replicast networking configuration.

* edit [nesetup.json](https://github.com/Nexenta/nedge-dev/blob/master/conf/gateway/nesetup.json) - [download](https://raw.githubusercontent.com/Nexenta/nedge-dev/master/conf/gateway/nesetup.json) from "gateway" profile (located in conf directory) and copy it over to some dedicated container directory, e.g. /root/c0

### Step 3: Create service configuration
Use NEADM management tool to setup service parameters, at the minimum execute this command below so that it will create service with name "nfs-finance":
```
neadm service create nfs nfs-finance
```

### Step 4: Run NexentaEdge GW NFS service across cluster
There is no limits on how many GW containers can existing within Replicast network. Start the NexentaEdge service container with the following run command:
```
mkdir -p /root/c0/var
mount --make-shared /
docker run --ipc host --network host --name nedge-nfs-finance \
	-e CCOW_SVCNAME=nfs-finance \
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
neadm service add nfs-finance SERVERID
```

Create bucket to share via NFS:
```
neadm bucket create company-branch1/finance/statistics
```

Share bucket:
```
neadm nfs share nfs-finance company-branch1/finance/statistics
```

Now we have a bucket exported, mountable via NFS protocols.

### Step 5: Verify that service is running
Run on the client to verify that portmapper listening:
```
rpcinfo -p
   program vers proto   port  service
    100000    4   tcp    111  portmapper
    100000    3   tcp    111  portmapper
    100000    2   tcp    111  portmapper
    100000    4   udp    111  portmapper
    100000    3   udp    111  portmapper
    100000    2   udp    111  portmapper
```

See if export shows up on the client:
```
showmount -e 127.0.0.1 | grep statistics
```

### Step 6: Verify that volume is functional with Docker ndnfs volume driver
Create new volume myvol1. Volume will be created and you should be able to inspect it:

```
docker volume create -d ndnfs --name myvol1 -o tenant=company-branch1/finance
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
