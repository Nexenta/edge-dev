![logo](https://nexenta.com/rs/nexenta2/images/Nexenta-GL-logo-600-dpi.jpg)

[![Docker Pulls](https://img.shields.io/docker/pulls/nexenta/nedge.svg)](https://hub.docker.com/r/nexenta/nedge)

# NexentaEdge DevOps Edition
NexentaEdge DevOps Edition is a purpose built and packaged solution for providing a scale-out infrastructure for containerized applications. It is designed to make it easy to integrate an enterprise class storage system with existing networking and compute services into a single solution.

NexentaEdge DevOps Edition nodes are deployed as containers on physical or virtual hosts, pooling all their storage capacity and presenting it as native block devices, NFS shares, or S3 objects to containerized applications running on the same servers.  All storage services are managed through standard Docker tools, for greater agility and scalability.

![fig1: deplyoment](https://raw.githubusercontent.com/nexenta/nedge-dev/master/images/container-converged.png)

NexentaEdge DevOps Edition provides the latest advanced storage features of NexentaEdge to containerized applications:
* Deployed as containers and managed using standard container tools
* Docker Volume drivers for File (NFS) and Block (NBD)
* Scale-out high performance data layer that provide self-healing error correction and automatic load balancing
* Scale-out high performance metadata layer with global Name Spaces and built-in multi-tenancy support
* Unlimited number of space optimized snapshots and clones
* Inline cluster wide deduplication and compression
* Micro-services for data access to Scale-Out File (NFS), Scale-Out Block (NBD/iSCSI), and Object (S3/SWIFT) services
* Quality of Service for storage services
* Multi-site high-performance bi-directional replication

Continue with more examples and [Quick Start Guides](https://github.com/nexenta/edge-dev/blob/master/INSTALL.md)

Please join us at the [NexentaEdge Devops community](https://community.nexenta.com/s/topic/0TOU0000000brtXOAQ/nexentaedge) site.

**Note:**<br/>The full documentation for NexentaEdge Enterprise Edition is [available here](https://nexenta.com/products/nexentaedge).
