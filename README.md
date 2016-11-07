![logo](https://nexenta.com/rs/nexenta2/images/Nexenta-GL-logo-600-dpi.jpg)

# NexentaEdge DevOps Edition

NexentaEdge DevOps Edition is purpose built, container converged scale-out storage solution with full set of Enterprise class features. Run Hadoop/Spark, Cassandra, Jenkins, or any application (Scale-out NFS, iSCSI block, S3/Swift Object) in Docker on commodity x86 servers

## Introduction

Containers, Orchestrations, Cloud technologies and proliferation of DevOps tools help make applications portable among private and public clouds. Elasticity and Flexibility are two missing properties of todays software defined data planes. A new, distributed approach is needed to storage, manage, and protect data across hybrid landscape. Using a modern, ultra scalable architecture, Nexenta software defined scale out solution NexentaEdge solves this problem. We call it Flexible Data Plane for Container-Converged solutions:

![fig1: deplyoment](https://raw.githubusercontent.com/nexenta/nedge-dev/master/images/container-converged.png)

Flexible Data Plane overcomes the frictions and economics of traditional storage. It provides a single, programmable data management layer that spans across workloads, clouds and tiers.

## Flexible Workloads:

Support any application and major data plane consumers. Traditional storage creates islands of SAN, NAS and object storage to support different applications and OSs. The Flexible Data Plane removes friction in management and necessity for extra copies between the islands by providing unified data storge platform

## Flexible Cloud Integrations:

Span private and public clouds. Traditional storage doesn't natively support public clouds. The Flexible Data Plane spins up in any cloud, creating a single data layer that replicates among private or public sites. Integration for any types of data (SAN, NAS and Object), bi-directional and incremental transferring makes multi-site replication feature unique and flexible in usage

## Flexible data tenancy, QoS and micro-services:

Collapse traditional storage tiers by introducing bottom up tenancy at storage, networking and compute level. Traditional storage platforms are designed for discrete tiers for isolated workloads. The Flexible Data Plane exposes comprehensive multi-tenancy way of managing IT infrastructure by providing unique way of combining data storage smart placements, storage / networking QoS and micro-services together

## Flexible performance characteristics and smart data placement:

Utilize disk and network capacities to its maximum by introducing smart data placements. Every I/O in NexentaEdge placed efficiently, preserving QoS guarantees and at the maximum speed possible. Benefits provided by patented Replicasttm protocol and using high performance UDP transfers. Traditional storage makes poor choices of where I/O has to be placed which often causing I/O spikes and HW underutilization. The Flexible Data Plane maximizes return from HW investments

## Unprecedented data integrity guarantees:

Provide end-to-end data integrity to application. NexentaEdge patented CCOWtm  technology uses strong and flexible cryptographic checksums (SHA2 and SHA3) to detect and self-heal data corruptions. If a disk returns bad data transiently CCOW will detect it and retry the read. The Flexible Data Plane built on top of CCOW technology will both detect and correct the error: it will use the cryptographic hash to determine which copy is correct, provide good data to the application, and repair the damaged copy automatically.

Capabilities of Flexible Data Plane:

* Scale-out, high performance architecture
* Native multi-site replication to / from heterogeneous clouds and between data centers
* Full automation and orchestration support
* Micro-services specific data services
* Unique combination of scale up and scale out from one vendor via Fusion API framework

The NexentaEdge is the only software-defined solution built with the above capabilities. It was designed from the ground up as a modern, distributed unified storage platform that can run on any commodity server and in any public cloud.

>**Note:**<br/>The full NexentaEdge Documentation is [available here](http://www.nexenta.com)

## Install and Quick Start Guides
NexentaEdge designed to run in Linux containers, as baremetal on-premis or in the cloud. It is true object storage high-performance scale out solution with File, Block and Object interfaces tightly integrated with container applications. Purporse built for usage with containers, to help design massively scalable and large data greedy applications.

# Contact Us
As you use NexentaEdge, please share your feedback and ask questions. Find the team on [NexentaEdge Forum](https://community.nexenta.com/s/topic/0TOU0000000brtXOAQ/nexentaedge).

If your requirements extend beyond the scope of DevOps Edition, then please contact [Nexenta](https://nexenta.com/contact-us) for information on NexentaEdge Enterprise Edition.

## Reference

## Description of ccow.json 
This file defines configuration used by CCOW client library.

| Field     | Description                                                                                                    | Example                              | Required |
|-----------|----------------------------------------------------------------------------------------------------------------|--------------------------------------|----------|
| tenant/failure_domain | Defines desirable failure domain for the container. 0 - single node, 1 - server, 2 - zone          | 1                                    | required |
| network/broker_interfaces  | The network interface for GW function, can be same as in ccowd.json                           | eth0                                 | required |

## Description of ccowd.json 
This file defines configuration used by CCOW daemon.

| Field     | Description                                                                                                    | Example                              | Required |
|-----------|----------------------------------------------------------------------------------------------------------------|--------------------------------------|----------|
| network/server_interfaces  | The network interface for DATA function                                                       | eth0                                 | required |
| transport | Default transport mechanism. Supported options: rtrd (RAW Disk Interface), rtlfs (On top of FileSystem)        | rtrd                                 | required |

## Description of corosync.conf (only important parameters)
This file defines configuration used by CCOW coordination service.

| Field     | Description                                                                                                    | Example                              | Required |
|-----------|----------------------------------------------------------------------------------------------------------------|--------------------------------------|----------|
| nodeid    | Unique int64 number. Has to be globally cluster unique value.                                                  | 1                                    | required |
| interface/bindnetaddr | Default networking interface for Corosync communication, can be same as in ccowd.json              | eth0                                 | required |

## Description of rt-rd.json
This file defines device configuration. Recommended for High Performance and better Disk space utilization as there is no filesytem overhead and data blobs written directly to device.

| Field     | Description                                                                                                    | Example                              | Required |
|-----------|----------------------------------------------------------------------------------------------------------------|--------------------------------------|----------|
| devices/name  | Unique device name as listed in /dev/disk/by-id/NAME                                                       | ata-VBOX_HARDDISK_VB370b5369-7d9ecbe0| required |
| devices/device | Kernel device name (used only for device description)                                                     | /dev/sdb                             | required |
| devices/journal | Unique device name as listed in /dev/disk/by-id/NAME (SSD) to be used as WAL journal and caching         | ata-VBOX_HARDDISK_VB370b5369-8e7a88e7| optional |

## Description of rt-lfs.json 
This file defines device configuration.

| Field     | Description                                                                                                    | Example                              | Required |
|-----------|----------------------------------------------------------------------------------------------------------------|--------------------------------------|----------|
| devices/name  | Unique device name as listed in /dev/disk/by-id/NAME                                                       | disk1                                | required |
| devices/path | Mountpoint to use. Supported file systems: EXT4, XFS and ZFS                                                | /data/disk1                          | required |
| devices/device | Kernel device name (used only for device description)                                                     | /dev/sdb                             | required |

## Description of auditd.ini
This file defines StatsD protocol compatible statistic aggregator configuration.

| Field     | Description                                                                                                    | Example                              | Required |
|-----------|----------------------------------------------------------------------------------------------------------------|--------------------------------------|----------|
| is_aggregator | Marks Data Container to become an aggregator and primary management endpoint                               | 0                                    | required |

## Requirements and Limitations
It is highly recommended that you run NexentaEdge DevOps Edition on a system with at least 16GB RAM.

|Requirement | Notes |
|---------------|---------|
|Kernel Version|4.4 or higher|
|Docker Version|1.12 or higher|
|CPU|4 cores minimally recommended|
|Network|Dedicated, VLAN isolated networking interface for Replicast I/O|
|Memory|16GB Minimum|
|Cloud|If running in the cloud, AWS Ubuntu 16.04 LTS (HVM) CentOS7.2 with Updates HVM|

Other limitations:

| Resource | Limit |
|------------|-------|
| Max Total Phyisical Capacity | 32TB |
| Minimal number of disks per Data Container | 4 |

