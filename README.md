![logo](https://nexenta.com/rs/nexenta2/images/Nexenta-GL-logo-600-dpi.jpg)

[![Docker Pulls](https://img.shields.io/docker/pulls/nexenta/nedge.svg)](https://hub.docker.com/r/nexenta/nedge)

# NexentaEdge DevOps Edition
NexentaEdge DevOps Edition is a purpose built and packaged software stack for providing a scale-out infrastructure for containerized applications. It is designed to make it easy to integrate an enterprise class storage system with existing networking and compute services into a single solution.

NexentaEdge DevOps Edition nodes are deployed as containers on physical or virtual hosts, pooling all their storage capacity and presenting it as native block devices (NBD), iSCSI, NFS shares, or fully compatbile S3/SWIFT object access for containerized applications running on the same servers.  All storage services are managed through standard Docker tools, for greater agility and scalability.

NexentaEdge purpose built Software Stack enables third-party vendors to deliver complete end-user solutions with benefits of component re-usability and unique feature set.

![fig1: deplyoment](https://raw.githubusercontent.com/nexenta/nedge-dev/master/images/container-converged.png)

NexentaEdge DevOps Edition provides advanced storage features of NexentaEdge to containerized applications:
* Deployed as containers and managed using standard container tools (DevOps style)
* Deployed as full Software Stack, including Enterprise grade GUI and features: availability, managability and scalability
* Docker Volume drivers for File (NFS) and Block (NBD)
* Scale-out high performance data layer that provide self-healing error correction and automatic load balancing
* Scale-out high performance metadata layer with global Name Spaces and built-in multi-tenancy support
* Unlimited number of space optimized snapshots and clones
* Inline cluster wide deduplication and compression
* Off-line "Quick" Erasure Coding without performance penalty on writes or reads with distributed rebuild
* Micro-services for data access to Scale-Out File (NFS), Scale-Out Block (NBD/iSCSI), and Object (S3/SWIFT) services
* Protocol transparency. Objects/Files/LUNs can be accessed from any protocol - NFS, S3 or SWIFT
* Quality of Service for storage services (per-tenant controlled rate limiting)
* Multi-site high-performance bi-directional continuous and "one-shot" replication
* High performance Raw Disk backend designed for All-Flash, Hybrid (HDD/SSD) and large capacity HDDs

Deploy Container-Converged infrastructure following [automatic procedure](https://github.com/nexenta/edge-dev/blob/master/install/automatic-deployment.md) (Enterprise style)

Or continue with more examples and deploy [Quick Start Guides](https://github.com/nexenta/edge-dev/blob/master/INSTALL.md) (DevOps style)

Please join us at the [NexentaEdge Devops community](https://community.nexenta.com/s/topic/0TOU0000000brtXOAQ/nexentaedge) site.

Ask immediate question on [NexentaEdge Developers Channel](https://nexentaedge.slack.com/messages/general/)

**Note:** The full documentation for NexentaEdge Enterprise Edition is [available here](https://nexenta.com/products/nexentaedge).
