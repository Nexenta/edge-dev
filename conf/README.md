# Configuration Profiles

**default**: NexentaEdge factory default settings. Up to three nodes, No SSD caching or WAL

**single-node**: NexentaEdge can be installed on a single node. Failure Domain will be limited to per-disk basis.

**high-performance**: Up to three nodes. HDDs can be grouped with SSD used for WAL and caching

**large-object-throughput**: Up to three nodes. HDD only, WAL disabled, Read-Ahead set to 1MB. Optional sync=0 (async commit)

**gateway**: NexentaEdge factory default for typical gateway container. No disks, just to serve protocol access function (NFS, Block or Object)
