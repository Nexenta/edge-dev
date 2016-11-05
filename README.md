![logo](https://nexenta.com/rs/nexenta2/images/Nexenta-GL-logo-600-dpi.jpg)

# NexentaEdge DevOps Edition

NexentaEdge DevOps Edition is purporse built, container converged scale-out storage solution with full set of Enterprise class features. Run Hadoop/Spark, Cassandra, Jenkins, or any application (Scale-out NFS, iSCSI block, S3/Swift Object) in Docker on commodity x86 servers

>**Note:**<br/>The full NexentaEdge Documentation is [available here](http://www.nexenta.com)

## Install and Quick Start Guides
NexentaEdge designed to run in Linux containers, as baremetal on-premis or in the cloud. It is true object storage high-performance scale out solution with File, Block and Object interfaces tightly integrated with container applications. Purporse built for usage with containers, to help design massively scalable and large data greedy applications.

# Contact Us
As you use NexentaEdge, please share your feedback and ask questions. Find the team on [NexentaEdge Forum](https://community.nexenta.com/s/topic/0TOU0000000brtXOAQ/nexentaedge).

If your requirements extend beyond the scope of DevOps Edition, then please contact [Nexenta](https://nexenta.com/contact-us) for information on NexentaEdge Enterprise Edition.

## Reference

## Description of ccow.json 

| Field     | Description                                                                                                    | Example                              | Required |
|-----------|----------------------------------------------------------------------------------------------------------------|--------------------------------------|----------|
| tenant/failure_domain | Defines desirable failure domain for the container. 0 - single node, 1 - server, 2 - zone          | 1                                    | required |
| network/broker_interfaces  | The network interface for GW function, can be same as in ccowd.json                           | eth0                                 | required |

## Description of ccowd.json 

| Field     | Description                                                                                                    | Example                              | Required |
|-----------|----------------------------------------------------------------------------------------------------------------|--------------------------------------|----------|
| network/server_interfaces  | The network interface for DATA function                                                       | eth0                                 | required |
| transport | Default transport mechanism. Supported options: rtrd (RAW Disk Interface), rtlfs (On top of FileSystem)        | rtrd                                 | required |

## Description of corosync.conf (only important parameters)

| Field     | Description                                                                                                    | Example                              | Required |
|-----------|----------------------------------------------------------------------------------------------------------------|--------------------------------------|----------|
| nodeid    | Unique int64 number. Has to be globally cluster unique value.                                                  | 1                                    | required |
| interface/bindnetaddr | Default networking interface for Corosync communication, can be same as in ccowd.json              | eth0                                 | required |

## Description of rt-rd.json (Recommended for High Performance and better Disk space utilization)

| Field     | Description                                                                                                    | Example                              | Required |
|-----------|----------------------------------------------------------------------------------------------------------------|--------------------------------------|----------|
| devices/name  | Unique device name as listed in /dev/disk/by-id/NAME                                                       | ata-VBOX_HARDDISK_VB370b5369-7d9ecbe0| required |
| devices/device | Kernel device name (used only for device description)                                                     | /dev/sdb                             | required |

## Description of rt-lfs.json 

| Field     | Description                                                                                                    | Example                              | Required |
|-----------|----------------------------------------------------------------------------------------------------------------|--------------------------------------|----------|
| devices/name  | Unique device name as listed in /dev/disk/by-id/NAME                                                       | disk1                                | required |
| devices/path | Mountpoint to use. Supported file systems: EXT4, XFS and ZFS                                                | /data/disk1                          | required |
| devices/device | Kernel device name (used only for device description)                                                     | /dev/sdb                             | required |

## Requirements and Limitations
It is highly recommended that you run NexentaEdge DevOps Edition on a system with at least 16GB RAM.

|Requirement | Notes |
|---------------|---------|
|Kernel Version|4.4 or higher|
|Docker Version|1.12 or higher|
|CPU|4 cores minimally recommended|
|Memory|16GB Minimum|
|Cloud|If running in the cloud, AWS Ubuntu 16.04 LTS (HVM) CentOS7.2 with Updates HVM|

Other limitations:

| Resource | Limit |
|------------|-------|
| Max Total Phyisical Capacity | 32TB |

