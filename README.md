![logo](https://nexenta.com/rs/nexenta2/images/Nexenta-GL-logo-600-dpi.jpg)

[![Docker Pulls](https://img.shields.io/docker/pulls/nexenta/nedge.svg)](https://hub.docker.com/r/nexenta/nedge)

# NexentaEdge DevOps Edition
Fast, feature rich and easy to use File, Block and Object storage for your Cloud-Native Applications. It is designed to make use of off the shelf storage and networking infrastructure and present it as enterprise grade SDS (Software-Defined Storage) solution.

NexentaEdge deployed as containers on physical or virtual hosts, pooling allocated storage capacity and presenting it for consumption by applications.  NexentaEdge designed with High-Performance and Data Reduction in mind. It provides best in class throughput and latency characteristics while saving overall allocated space with built-in in-line global De-Duplication, Compression and off-line Erasure Encoding.

*NexentaEdge is ideal solution if you want to consolidate multiple data protocol multi-tenant access into one shared fabric with globally enabled deduplication and compression across all the high-level protocols:

- AWS compatible S3 object protocol
- EdgeX-S3 - NexentaEdge specific extensions (RW objects, Snapshots/Clones, NOSQL K/V Database, and more)
- OpenStack SWIFT object protocol
- iSCSI with Active/Passive HA
- NFSv3 with Active/Passive HA and horizontally Scale-Out
- NBD - Native Block Device (no iSCSI overhead, connected directly to Replicast backend network)

*Key benefits to consider:*

- **Easy of use** with advanced CLI and nice GUI
- **Enhanced data integrity, availability and reliability** with state of the art Cloud scale Copy-on-Write ("CCOW") architecture and design
- **Global In-Line Deduplication an compression** across all supported storage protocols
- **Predictable latency and performance** with Dynamic Data Placement and Location independent data chunk Retrieval
- **Enhanced security** with guaranteed immutability at all levels: metadata and data chunks and built-in Encryption
- **Scalable Global Namespace** without the need for dedicated Metadata Servers
- **Multi-Tenancy and QoS** across all supported storage protocols
- **High-Performance Erasure Encoding** with close to zero, off-line impact on frontend write and read I/O

Learn more at [http://nexentaedge.io](http://nexentaedge.io) community website.
