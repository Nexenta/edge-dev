## Initialization and setting up DevOps license
Once one or more Data Containers successfully installed, system needs to be initialized and can then be fully managed via NEADM management tool

### Step 1: Install NEADM management tool

TODO

### Step 2: Obtain license and activate cluster
```
root@host:~/neadm ./neadm system init
STATUS: Cluster in consistent state
NexentaEdge cluster initialized successfully.
System GUID: 39E2BABD-E550-4872-892C-6A537FEA8CC3
Service checkpoint created successfully

root@host:~/neadm ./neadm system license set online LICENSE-KEY
```

### Step 3: Create cluster namespace and at least one tenant within it
```
root@host:~/neadm ./neadm cluster create company-branch1

root@host:~/neadm ./neadm tenant create company-branch1/finance
```

### To see running cluster nodes and its devices
```
root@host:~/neadm ./neadm device list
ZONE:HOST:CID                           SID/DEVID                        UTIL CAP  RLAT WLAT REPQ STATE
0:nexentaedge2:nexentaedge2             000443D7E9501E4E9878FFE78178637C
  ata-VBOX_HARDDISK_VB370b5369-7d9ecbe0 27FAB8C7E65F2F1EC8F0A0D437503430 0%   4.5G 8    10   0    ONLINE
  ata-VBOX_HARDDISK_VBd216059f-af9a543e 9B55076475DAFE2BFA7659A3AC7129AA 0%   4.5G 19   65   0    ONLINE
  ata-VBOX_HARDDISK_VBd6aa9f3d-21ab325e A5EF2716EC77EA2062AA63D14BCA0E4F 0%   4.5G 18   0    0    ONLINE
  ata-VBOX_HARDDISK_VB001dd984-88d250f1 42A5A5AEC832765A9DF7F42FA0CB9E41 0%   4.5G 6    44   0    ONLINE
```
