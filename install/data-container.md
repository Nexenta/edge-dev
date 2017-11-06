## Installing and Running NexentaEdge DevOps Edition Data holding container
This guide will explain how to setup Data hold service container on one or more servers. DevOps Edition supports up to 3 data containers on the same Replicast network. See [Requirements and Limitations](https://github.com/Nexenta/edge-dev/blob/master/INSTALL.md#requirements-and-limitations) section for additional details.

### Step 1: Setting up Replicast network
NexentaEdge design for high performance and massive scalability beyound 1000 servers per cluster. It doesn't have central metadata server or coordination server. Its design is shared nothing with metadata and data fully distributed across the cluster. To work optimally NexentaEdge requires dedicated backend high-performance network, isolated with VLAN segment and set for Jumbo Frames.

Follow guide lines from installation guide with regards of setting up [Replicast network](https://github.com/Nexenta/edge-dev/blob/master/INSTALL.md#step-1-setting-up-replicast-network).

### Step 2: Prepare local host configuration for Data Container
There are example configuration files (see conf directory) to modify. Follow guide lines from installation guide with regards of [setting up Disks](https://github.com/Nexenta/edge-dev/blob/master/INSTALL.md#step-2-prepare-nesetupjson-file-raw-disks-and-set-optimal-host-sysctl-parameters)

### Step 3: Run NexentaEdge Data Nodes across cluster

* create empty var directory. This directory will persistently keep containers information necesary to have across restarts and reboots.

```
mkdir /root/c0/var
```

* starting with host networking configuration. Ensure that host has ports 8080 not used and available. Port 8080 (default) will be used to respond to REST API requests.

```
netstat -ant|grep "8080"|grep LISTEN
docker run --ipc host --network host --name nedge-data0 \
	-e HOST_HOSTNAME=$(hostname) -d -t -i --privileged=true \
	-v /root/c0/var:/opt/nedge/var \
	-v /root/c0/nesetup.json:/opt/nedge/etc/ccow/nesetup.json:ro \
	-v /dev:/dev \
	-v /run/docker/plugins:/run/docker/plugins \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v /etc/localtime:/etc/localtime:ro \
        nexenta/nedge start -j ccowserv -j rest
```

At this point you will have Data Containers running and forming cluster. Networking configuration for backend is automatic IPv6 discovery based.
