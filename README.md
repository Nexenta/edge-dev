![logo](https://nexenta.com/rs/nexenta2/images/Nexenta-GL-logo-600-dpi.jpg)

[![Docker Pulls](https://img.shields.io/docker/pulls/nexenta/nedge.svg)](https://hub.docker.com/r/nexenta/nedge)

# NexentaEdge DevOps Edition
NexentaEdge DevOps Edition is a purpose built and packaged software stack for providing a scale-out infrastructure for containerized applications. It is designed to make it easy to integrate an enterprise class storage system with existing networking and compute services into a single solution.

NexentaEdge DevOps Edition nodes are deployed as containers on physical or virtual hosts, pooling all their storage capacity and presenting it as native block devices (NBD), iSCSI, NFS shares, or fully compatbile S3/SWIFT object access for containerized applications running on the same servers.  All storage services are managed through standard Docker tools, for greater agility and scalability.

# NexentaEdge Extended S3-compatible API

NexentaEdge Extended S3 API provides unique benefits which can be useful for Machine Deep Learning, Big Data and IoT frameworks:

* Mount S3 objects for fast File/POSIX access avoid unnecessary copy, fetch only needed datasets
* Extended S3 feature set Append, Range Writes, Object/Bucket snapshots, Key-Value Object access
* Data Reduction with global inline de-duplication, compression and erasure encoding
* Cost Reduction File/Block/DB access with S3 economics 

Use cases details:

* Advanced Versioned S3 Object Append and RW "Object as File" access
* S3 Object as a Key-Value database, including integrations w/ Caffe, TensorFlow, Spark, Kafka, etc
* High-performance Versioned S3 Object Stream Session (RW), including FUSE library to mount an object
* Management API for Snapshots and Clones, including Bucket instantaneous snapshots
* Transparent NFS to/from S3 bucket access, “ingest via NFS, read via S3” or vice-versa

Comparision to existing cloud object storage APIs:

![fig1: EdgeVsS3](https://raw.githubusercontent.com/nexenta/nedge-dev/master/images/EdgeVsS3.png)

Give Edge-X S3 a try in easy to run single command installation:

```console
    # location where to keep blobs
    mkdir /var/tmp/data
    
    # start nexenta/nedge daemon and Edge-X S3 compatible service
    docker run --name s3data -v /etc/localtime:/etc/localtime:ro -v /var/tmp/data:/data -d \
            nexenta/nedge start -j ccowserv -j ccowgws3

```

Follow up with our Community! Please join us at the [NexentaEdge Devops community](https://community.nexenta.com/s/topic/0TOU0000000brtXOAQ/nexentaedge) site.

* [Register DevOps account and obtain license key here](https://community.nexenta.com/s/devops-edition)
* Use e-mailed ACTIVATION_KEY to activate installation

The following are the steps to initialize, setup region namespace, tenant, service:
    
```console
    # setup alias for easy CLI style management
    alias neadm="docker exec -it s3data neadm"
    
    # verify that service is running
    docker exec -it s3data neadm system status
    
    # initialize and setup devops license
    neadm system init
    neadm system license set online ACTIVATION_KEY
    
    # setup simple Edge-X S3 service
    neadm cluster create region1
    neadm tenant create region1/tenant1
    neadm service create s3 s3svc
    neadm service serve s3svc region1/tenant1
    neadm service add s3svc SERVERID  # use neadm system status to find out 
    neadm service restart s3svc
    neadm service show s3svc
    
    # assuming that default Docker bridge address asigned to container
    # is 172.17.0.3 verify that Edge-X S3 port is listening
    curl http://172.17.0.3:9982
```

Setup GUI for easy on-going management and monitoring:

```console
    docker run -e API_ENDPOINT=http://172.17.0.3:8080 -p 3000:3000 \
        nexenta/nedgeui:2.1.0
```

* Point browser to the host's port 3000
* Default user/password: admin/nexenta
* You know show be able to manage and monitor your simple single node cluster!

![fig2: gui-s3svc](https://raw.githubusercontent.com/nexenta/nedge-dev/master/images/nedgeui-s3svc.png)

NexentaEdge purpose built Software Stack enables third-party vendors to deliver complete end-user solutions with benefits of component re-usability and unique feature set.

![fig3: deplyoment](https://raw.githubusercontent.com/Nexenta/edge-dev/master/images/nedgeui-s3svc.png)

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

# Advanced deployment scenarios:

Deploy Container-Converged infrastructure following [automatic procedure](https://github.com/nexenta/edge-dev/blob/master/install/automatic-deployment.md) (Enterprise style)

Or continue with more examples and deploy [Quick Start Guides](https://github.com/nexenta/edge-dev/blob/master/INSTALL.md) (DevOps style)

Ask immediate question on [NexentaEdge Developers Channel](https://nexentaedge.slack.com/messages/general/)

**Note:** The full documentation for NexentaEdge Enterprise Edition is [available here](https://nexenta.com/products/nexentaedge).
