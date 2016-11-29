## Installing and Running NexentaEdge Scale-Out Native Block (NBD) service container

### Step 1: Setting up Replicast network
NexentaEdge design for high performance and massive scalability beyound 1000 servers per cluster. It doesn't have central metadata server or coordination server. Its design is shared nothing with metadata and data fully distributed across the cluster. To work optimally NexentaEdge requires dedicated backend high-performance network, isolated with VLAN segment and set for Jumbo Frames.

Follow guide lines from from Data Container with regards of setting up Replicast network.

### Step 2: Prepare local host configuration for GW Container
There are example configuration files (see conf directory) to modify. Adjust networking interface. 

### Step 3: Prepare serving bucket
Use NEADM management tool to setup service parameters. Assuming that cluster is initialized and namespace/tenant already created, create bucket where block devices will be automatically appearing with names matching Docker volume names:
```
neadm bucket create company-branch1/finance/revenue
```

### Step 4: Run NexentaEdge GW NBD service across cluster
The below command assumes that cluster is already operational and it will only start GW NBD function as a separate container. However, it is possible to start NBD service as a part of Data container by providing "-j nbdserv" option. There is no limits on how many GW containers can existing within Replicast network. Start the NexentaEdge service container with the following run command:
```
modprobe nbd nbds_max=64
mount --make-shared /
docker run --ipc host --name nedge-nbd-revenue \
	-e HOST_HOSTNAME=$(hostname) -d -t -i --privileged=true \
	-v /root/c0/var:/opt/nedge/var \
	-v /root/c0/nesetup.json:/opt/nedge/etc/ccow/nesetup.json:ro \
	-v /dev:/dev \
	-v /var/lib/ndvol:/var/lib/ndvol:shared \
	-v /run/docker/plugins:/run/docker/plugins \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v /etc/localtime:/etc/localtime:ro \
        nexenta/nedge /opt/nedge/nmf/nefcmd.sh start -j nbdserv -j rest
```

At this point you will have NBD service running and exporting "ndvol" Docker volume driver.

### Step 5: Verify that volume is functional
Create new volume myvol1. Volume will be created and you should be able to inspect it:

```
docker volume create -d ndvol --name myvol1 -o size=16G -o bucket=company-branch1/finance/revenue
docker volume inspect myvol1
[
    {
        "Name": "myvol1",
        "Driver": "ndvol",
        "Mountpoint": "/var/lib/ndvol/myvol1",
        "Labels": {},
        "Scope": "local"
    }
]
```

Corresponding new NBD device also will be created. List it using neadm command and specify unique ServerId:
```
neadm device nbd list 000472A07C763F60D530F8211B3B5CF9
DEV       CHUNK_SIZE LUN_SIZE REPCOUNT OBJPATH
/dev/nbd1 32K        16G      3        company-branch1/finance/revenue/myvol1
```

Start some container and attach volume to it, you will see that volume will be automatically formated (default is xfs) and mounted:
```
docker run -v myvol1:/tmp -dit alpine /bin/sh
mount | grep myvol1
/dev/nbd1 on /var/lib/ndvol/myvol1 type xfs (rw,relatime,attr2,inode64,noquota)
```

Stop/Remove container and you should see that volume is automatically unmounted
