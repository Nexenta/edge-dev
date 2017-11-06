## Installing and Running NexentaEdge Scale-Out Shared NameSpace iSCSI protocol compatible service container

### Step 1: Setting up Replicast network
NexentaEdge design for high performance and massive scalability beyound 1000 servers per cluster. It doesn't have central metadata server or coordination server. Its design is shared nothing with metadata and data fully distributed across the cluster. To work optimally NexentaEdge requires dedicated backend high-performance network, isolated with VLAN segment and set for Jumbo Frames.

Follow guide lines from installation guide with regards of setting up [Replicast network](https://github.com/Nexenta/edge-dev/blob/master/INSTALL.md#step-1-setting-up-replicast-network).

### Step 2: Prepare local host configuration for Data Container
There are example configuration files (see conf directory) to modify. Adjust networking interface. Typicaly first port assigned will be eth0.

* edit [nesetup.json](https://github.com/Nexenta/nedge-dev/blob/master/conf/gateway/nesetup.json) - [download](https://raw.githubusercontent.com/Nexenta/nedge-dev/master/conf/gateway/nesetup.json) from "gateway" profile (located in conf directory) and copy it over to some dedicated container directory, e.g. /root/c0

### Step 3: Create service configuration
Use NEADM management tool to setup service parameters
```
neadm service create iscsi iscsi-mongodb
```

### Step 4: Run NexentaEdge GW iSCSI scale-out block service across cluster
There is no limits on how many GW containers can existing within Replicast network. Start the NexentaEdge service container with the following run command:
```
docker run --ipc host --network host --name nedge-iscsi-mongodb \
	-e CCOW_SVCNAME=iscsi-mongodb \
	-e HOST_HOSTNAME=$(hostname) -d -t -i --privileged=true \
	-v /root/c0/var:/opt/nedge/var \
	-v /root/c0/nesetup.json:/opt/nedge/etc/ccow/nesetup.json:ro \
	-v /dev:/dev \
	-v /etc/localtime:/etc/localtime:ro \
        nexenta/nedge start -j iscsiserv
```

At this point you will have iSCSI service running. Add SERVERID (can be found with command "neadm system status") to the service:

```
neadm service add iscsi-mongodb SERVERID
```

Create at least one bucket to serve iSCSI objects (LUNs) from:

```
neadm bucket create company-branch1/finance/databases
```

Create 8gb LUN with 128K chunk size and replication count 2:

```
neadm iscsi create iscsi-mongodb company-branch1/finance/databases/LUN1 8G -s 128K -r 2
```

At this point you will have iSCSI block service running and exporting LUN to serve MongoDB database

### Step 6: Verify that service is running

Check that LUNs registered with target database:

```
neadm iscsi status iscsi-mongodb
Server: 20E16ED70A3A946AAE7DF0CF8823F508:
Target 23008: iqn.2005-11.nexenta.com:23008
    System information:
        Driver: iscsi
        State: ready
    I_T nexus information:
    LUN information:
        LUN: 0
            Type: controller
            SCSI ID: IET     59e00000
            SCSI SN: beaf230080
            Size: 0 MB, Block size: 1
            Online: Yes
            Removable media: No
            Prevent removal: No
            Readonly: No
            SWP: No
            Thin-provisioning: No
            Backing store type: null
            Backing store path: None
            Backing store flags:
        LUN: 1
            Type: disk
            SCSI ID: 64CF2A0D808C6D1A
            SCSI SN: beaf230081
            Size: 8590 MB, Block size: 4096
            Online: Yes
            Removable media: Yes
            Prevent removal: No
            Readonly: No
            SWP: No
	    Thin-provisioning: Yes
            Backing store type: ccowbd
            Backing store path: cltest/test/bk1/LUN1
            Backing store flags:
```

Check that service is listening for incoming iSCSI initiator requests:

netstat -ant|grep "3260"|grep LISTEN
