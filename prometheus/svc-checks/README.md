## Prometheus exporters for NexentaEdge services
NexentaEdge has built-in Prometheus exporter which monitors internal states
and alerts. It is powerfull enough for majority of use cases.

In some cases availability of services (iSCSI, S3 and NFS) has to be closely
monitored. Service monitoring would need to be installed on client machines.

Start as a daemon with a command:

```
socat TCP4-LISTEN:8090,reuseaddr,fork EXEC:/path/to/script
```

Adjust prometheus.yml file and add more targets.

### NFS service health monitor

  Reported states:
 
   1    - service fully available
   0    - service partially available (likely networking issue)
  -1    - service unavailable (df command isn't working)
  -2    - service unavailable (showmount command isn't working)
  -3    - service unavailable (not mounted)

### iSCSI service health monitor

  Reported states:
 
   1	- service fully available
   0	- service LUNs not found
  -1	- service not discoverable (likely networking issue)

### S3 service health monitor

  Reported states:
 
   1	- service fully available
   0	- service bucket HEAD failed
  -1	- service object HEAD failed
  -2	- service not discoverable (likely networking issue)
