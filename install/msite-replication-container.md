## Installing and Running NexentaEdge Multi-Site continious replication container (EXPERIMENTAL)
This guide will explain how to setup inter-segment bi-directional replication service container on one or more servers. Assumption is that there are two clusters alredy setup and both functional.

### Step 1: Setting up Replicast network
NexentaEdge design for high performance and massive scalability beyound 1000 servers per cluster. It doesn't have central metadata server or coordination server. Its design is shared nothing with metadata and data fully distributed across the cluster. To work optimally NexentaEdge requires dedicated backend high-performance network, isolated with VLAN segment and set for Jumbo Frames.

Follow guide lines from from Data Container with regards of setting up Replicast network.

### Step 2: Prepare local host configuration for Data Container
There are example configuration files (see conf directory) to modify. Adjust networking interface. Typicaly first port assigned will be eth0.

* edit [nesetup.json](https://github.com/Nexenta/nedge-dev/blob/master/conf/gateway/nesetup.json) - [download](https://raw.githubusercontent.com/Nexenta/nedge-dev/master/conf/gateway/nesetup.json) from "gateway" profile (located in conf directory) and copy it over to some dedicated container directory, e.g. /root/c0

### Step 3: Create service configuration at company HQ (destination cluster)
Start the NexentaEdge service container with the following run command:
```
docker run --network host --name nedge-msite-hq \
        -e CCOW_SVCNAME=s3finance -e ISGW_SVCNAME=backup-server \
        -e HOST_HOSTNAME=$(hostname) -d -t -i --privileged=true \
        -v /root/c0/var:/opt/nedge/var \
        -v /root/c0/nesetup.json:/opt/nedge/etc/ccow/nesetup.json:ro \
        -v /dev:/dev \
        -v /etc/localtime:/etc/localtime:ro \
        -p 14000:14000 \
        nexenta/nedge /opt/nedge/nmf/nefcmd.sh start \
        -j ccowserv -j ccowgws3 -j isgwserv
```

If you are using port other than 14000, then map that port number (-p port:port).

Use NEADM management tool to setup s3 service

```
neadm service create s3 s3finance
neadm service configure s3finance X-Need-MD5 true
neadm service serve s3finance company-branch/departments
```

Use NEADM management tool to setup isgw (multi-site) service to receive the data from your company branch (source cluster)
```
neadm service create isgw backup-server
neadm service configure backup-server X-ISGW-Basic-Auth <user:password>
neadm service configure backup-server X-ISGW-Local <IPv4addr:port>
```

Example of isgw configuration is as follows:
```
neadm service create isgw backup-server
neadm service configure backup-server X-ISGW-Basic-Auth admin:admin
neadm service configure backup-server X-ISGW-Local 172.20.10.5:14000
```

Restart the container after confguration is complete.
```
docker stop <container-id>
docker start <container-id>
```
Your HQ container is now ready to receive the bucket (and its contents) from the branch office container.

### Step 4: Create service configuration at company branch (source cluster)
Start the NexentaEdge service container with the following run command:
```
docker run --network host --name nedge-msite-branch \
        -e CCOW_SVCNAME=s3finance -e ISGW_SVCNAME=backup-client \
        -e HOST_HOSTNAME=$(hostname) -d -t -i --privileged=true \
        -v /root/c0/var:/opt/nedge/var \
        -v /root/c0/nesetup.json:/opt/nedge/etc/ccow/nesetup.json:ro \
        -v /dev:/dev \
        -v /etc/localtime:/etc/localtime:ro \
        nexenta/nedge /opt/nedge/nmf/nefcmd.sh start \
        -j ccowserv -j ccowgws3 -j isgwserv
```

Use NEADM management tool to setup s3 service

```
neadm service create s3 s3finance
neadm service configure s3finance X-Need-MD5 true
neadm service serve s3finance company-branch/departments
```

Use NEADM management tool to setup isgw (multi-site) service to send the data to your company HQ (destination cluster)
```
neadm service create isgw backup-client
neadm service configure backup-client X-ISGW-Basic-Auth <user:password>
neadm service configure backup-client X-ISGW-Remote ccow://<IPv4addr:port>
```
Example of isgw configuration is as follows:
```
neadm service create isgw backup-client
neadm service configure backup-client X-ISGW-Basic-Auth admin:admin
neadm service configure backup-client X-ISGW-Remote 172.20.10.5:14000
neadm service serve backup-client company-branch/departments/finance
```
Restart the container after confguration is complete.
```
docker stop <container-id>
docker start <container-id>
```

At this point you will have Inter-Segment GW (ISGW) service running and syncing two buckets between the branch office and HQ.

### Step 5: Verify that service is running
Download s3cmd and configure it.

Run the following command on both the clusters (hosts)
```
s3cmd ls s3://
(This will display finance bucket)
```

Copy a file to 'finance' bucket on the branch side container
```
s3cmd put <file> s3://finance/
s3cmd ls s3://finance/
```

Check the 'finance' bucket on the HQ container
```
s3cmd ls s3://finance/
