![logo](https://nexenta.com/rs/nexenta2/images/Nexenta-GL-logo-600-dpi.jpg)

[![Docker Pulls](https://img.shields.io/docker/pulls/nexenta/nedge.svg)](https://hub.docker.com/r/nexenta/nedge)

# NexentaEdge DevOps Edition
*Leading container-converged scale-out solution!*

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

Utilize disk and network capacities to its maximum by introducing smart data placements. Every I/O in NexentaEdge placed efficiently, preserving QoS guarantees and at the maximum speed possible. Benefits provided by patented Replicast&trade; protocol and using high performance UDP transfers. Traditional storage makes poor choices of where I/O has to be placed which often causing I/O spikes and HW underutilization. The Flexible Data Plane maximizes return from HW investments

## Unprecedented data integrity guarantees:

Provide end-to-end data integrity to application. NexentaEdge patented CCOW&trade;  technology uses strong and flexible cryptographic checksums (SHA2 and SHA3) to detect and self-heal data corruptions. If a disk returns bad data transiently CCOW will detect it and retry the read. The Flexible Data Plane built on top of CCOW technology will both detect and correct the error: it will use the cryptographic hash to determine which copy is correct, provide good data to the application, and repair the damaged copy automatically.

Capabilities of Flexible Data Plane:

* Scale-out, high performance architecture
* Native multi-site replication to / from heterogeneous clouds and between data centers
* Full automation and orchestration support
* Micro-services specific data services
* Unique combination of scale up and scale out from one vendor via Fusion API framework

The NexentaEdge is the only software-defined solution built with the above capabilities. It was designed from the ground up as a modern, distributed unified storage platform that can run on any commodity server and in any public cloud.

>**Note:**<br/>The full NexentaEdge Enterprise Edition Documentation is [available here](http://www.nexenta.com)
