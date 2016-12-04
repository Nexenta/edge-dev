# Example Scripts

**nestart**: Helper script how to start NexentaEdge Docker container with multi-host, client/backend separate networks

Usage example:

Start Data Container and create default networks using two physical interfaces, one for Replicast, one for Client traffic
```
NETIF_REPNET=enp0s9 NETIF_CLNET=enp0s8 ./nestart /root/c0 -j ccowserv -j rest
```

Start S3 Gateway Container service connecting to default networks
```
CCOW_SVCNAME=s3finance ./nestart /root/c1 -j ccowgws3
```

Setup NEADM alias specifying nedge-mgmt network and see status of cluster with two containers on the same host
```
alias neadm="docker run -i -t --rm -v /root/di/c0/.neadmrc:/opt/neadm/.neadmrc --network nedge-mgmt nexenta/nedge-neadm /opt/neadm/neadm"
neadm system status
ZONE:HOST:CID             SID                              UTIL CAP CPU          MEM       DEVs STATE
0:myhost:84d099b8e9ec [M] B3862D3D760EEB8C877F15E5FC695ED5 0%   18G 4/0.1@2.2Ghz 4.5G/7.8G 4/4  ONLINE
0:myhost:e33e78f95e85     5A82191C0C8C3E28898D1443FE161D64 0%   -   4/0.1@2.2Ghz 4.5G/7.8G 0/0  ONLINE
```
