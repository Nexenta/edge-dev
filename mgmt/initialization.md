## Initialization and setting up DevOps license
Once one or more Data Containers successfully installed, system needs to be initialized and can then be fully managed via NEADM management tool

### Step 1: Install NEADM management tool
NexentaEdge defines set of well described REST APIs which provides easy way to manage complex cluster designs. Once REST module is enabled, container can be managed via NEADM management tool. Enterprise Edition provides additonal way of managing Storage, Networking and Compute via central graphical interface.

To enable NEADM tool, modify .neadmrc file to point to the right IPv4 address, port 8080 if not local and set the following or similar alias:
```
source /root/c0/.bash_completion
alias neadm="docker run -i -t --rm --network host -v /root/c0/.neadmrc:/opt/neadm/.neadmrc nexenta/nedge-neadm /opt/neadm/neadm"
```

### Step 2: Obtain license and activate cluster
```
neadm system init
STATUS: Cluster in consistent state
NexentaEdge cluster initialized successfully.
System GUID: 39E2BABD-E550-4872-892C-6A537FEA8CC3
Service checkpoint created successfully

neadm system license set online LICENSE-KEY
```

### Step 3: Create cluster namespace and at least one tenant within it
```
neadm cluster create company-branch1

neadm tenant create company-branch1/finance
```

### To see running cluster nodes and its devices
```
neadm device list
ZONE:HOST:CID                                  SID/DEVID                        UTIL CAP  RLAT WLAT REPQ STATE
0:nexentaedge2:nexentaedge2                    000443D7E9501E4E9878FFE78178637C
  ata-MICRON_M510DC_MTFDDAK800MBP_15351133916C E70004EB2CC4D0BBB2AFD93AEEC8B629 0%   750G 20   50   0    ONLINE
  ata-MICRON_M510DC_MTFDDAK800MBP_15351133916F C79311043CE7613858A15D36AE7A93D3 0%   750G 2    51   0    ONLINE
  ata-MICRON_M510DC_MTFDDAK800MBP_15351133919F F1DEBECEA44ACB0DA56CC5F0641F8486 0%   750G 19   48   0    ONLINE
  ata-MICRON_M510DC_MTFDDAK800MBP_153511339196 08BCFEC4C30FF4807723066E4C9F0134 0%   750G 19   51   0    ONLINE
```
