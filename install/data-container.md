## Installing and Running NexentaEdge DevOps Edition

### Step 1: Setting up Replicast network
NexentaEdge design for high performance and massive scalability beyound 1000 servers per cluster. It doesn't have central metadata server or coordination server. Its design is shared nothing with metadata and data fully distributed across the cluster. To work optimally NexentaEdge requires dedicated backend high-performance network, isolated with VLAN segment and set for Jumbo Frames.

Example to use macvlan as a Replicast L2 bridge:
```
ifconfig enp0s9 mtu 9000 up
modprobe macvlan
docker network create -d macvlan --subnet 192.168.10.0/24 -o parent=enp0s9 repnet
```

### Step 2: Prepare local host configuration for Data Container
There are 4 configuration files (see conf directory) to modify. Adjust networking port. Typicaly first port assigned will be eth0. Adjust rt-rd.json file to point to the correct devices.

### Step 3: Run NexentaEdge Data Nodes across cluster
Start the NexentaEdge data container with the following run command:
```
docker run --network repnet --name nedge-data0 \
	-e HOST_HOSTNAME=$(hostname) -d -t -i --privileged=true \
	-v /root/c0/rt-rd.json:/opt/nedge/etc/ccow/rt-rd.json \
	-v /root/c0/ccow.json:/opt/nedge/etc/ccow/ccow.json \
	-v /root/c0/ccowd.json:/opt/nedge/etc/ccow/ccowd.json \
	-v /root/c0/corosync.conf:/opt/nedge/etc/corosync/corosync.conf \
	-v /dev/disk:/dev/disk \
	-v /etc/localtime:/etc/localtime:ro \
	-v /etc/timezone:/etc/timezone:ro \
        nexenta/nedge /opt/nedge/nmf/nefcmd.sh start -j ccowserv
```

At this point you will have Data Containers running and forming cluster. Networking configuration for backend is automatic IPv6 discovery based.

### Step 4: Run NexentaEdge NEADM management tool
Start the NexentaEdge management tool with the following run command:

TODO
