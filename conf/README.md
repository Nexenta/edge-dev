# Configuration Profiles

**default**: NexentaEdge factory default settings. Minimally three nodes, No SSD caching and WAL

**single-node**: NexentaEdge can be installed with two or less nodes. Failure Domain will be limited to per-disk basis.

**high-performance**: Minimally three nodes. HDDs can be grouped with SSD used for WAL and caching

**large-object-throughput**: Minimally three nodes. HDD only, WAL disabled, Read-Ahead set to 1MB. Optional sync=0 (async commit)
