## Installing and Running NexentaEdge DevOps Edition

### Step 1: Setting up Replicast network
NexentaEdge design for high performance and massive scalability beyound 1000 servers per cluster. It doesn't have central metadata server or coordination server. Its design is shared nothing with metadata and data fully distributed across the cluster. To work optimally NexentaEdge requires dedicated backend high-performance network, isolated with VLAN segment and set for Jumbo Frames.

Data Container can be installed either in single or multiple instances. When it is installed as a single container, consider to use "--network host" option to simplify networking access for Replicast, Management and Client networks.

It is possible to install more then one Data Container and setup custom Replicast, Management and Client networks. Activation script needs to ensure that all networks exists and functional prior to starting container. For Replicast network it is recommended to use macvlan virtualization method. Example to use macvlan as a Replicast L2 bridge:
```
ifconfig enp0s9 mtu 9000 up
modprobe macvlan
docker network create -d macvlan --subnet 192.168.10.0/24 -o parent=enp0s9 repnet
```

### Step 2: Prepare local host configuration for Data Container
There are example configuration files (see conf directory) to modify. Adjust networking interface. Typicaly first port assigned will be eth0. Adjust rt-rd.json file to point to the correct devices.

### Step 3: Run NexentaEdge Data Nodes across cluster
Start the NexentaEdge data container with the following run command:
```
docker run --ipc host --network host --name nedge-data0 \
	-e HOST_HOSTNAME=$(hostname) -d -t -i --privileged=true \
	-v /root/c0/var:/opt/nedge/var \
	-v /root/c0/nesetup.json:/opt/nedge/etc/ccow/nesetup.json:ro \
	-v /dev:/dev \
	-v /run/docker/plugins:/run/docker/plugins \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v /etc/localtime:/etc/localtime:ro \
        nexenta/nedge /opt/nedge/nmf/nefcmd.sh start -j ccowserv
```

At this point you will have Data Containers running and forming cluster. Networking configuration for backend is automatic IPv6 discovery based.

### Step 4: Enable REST API service
Once REST API is enabled on the container, it can be managed via NEADM management tool
```
docker exec -it nedge-data0 /opt/nedge/nmf/nefcmd.sh adm enable rest
docker exec -it nedge-data0 /opt/nedge/nmf/nefcmd.sh adm status
Name                Type    Status    PID
auditserv           atomic  online    422
autosupport         atomic  disabled  -
ccowgw              atomic  disabled  -
ccowgws3            atomic  disabled  -
ccowgws3subdomains  atomic  disabled  -
ccowserv            atomic  online    633
disk                atomic  disabled  -
docker              atomic  disabled  -
echo                atomic  disabled  -
iscsiserv           atomic  disabled  -
isgwserv            atomic  disabled  -
logger              atomic  online    150
nbdserv             atomic  disabled  -
network             atomic  online    425
nfsserv             atomic  disabled  -
rest                atomic  online    2253
sysconfig           atomic  online    152
vip                 atomic  disabled  -
```
