## Upgrade or re-installation
This guide will explain how to upgrade or re-install exisiting environment

### Upgrade (DevOps style)

Shutdown currently running docker images using the following sequence on each node:

```
docker pull nexenta/nedge
docker rm -f NAME
```

where NAME is the name of your running container

On the node where NEADM is installed:

```
docker pull nexenta/nedge-neadm
```

Re-run your regular starting sequence

### Re-installation (DevOps style)

Follow upgrade sequence and shutdown all the nodes.

For each device "name" key in your nesetup.json execute the following command on each node:

```
docker run --rm --privileged=true -v /dev:/dev nexenta/nedge /opt/nedge/sbin/nezap --do-as-i-say DEVID [JOURNAL_DEVID]
```

Make sure to zap all the devices you listed in nesetup.json. Use optional JOURNAL_DEVID parameter to additionally zap journal/cache SSD.

Additionally prior to restart, clean up "var" directory for each data container, example:

```
rm -rf /root/c0/var/*
```

Re-run your regular starting sequence

### Upgrade (Enterprise Container Converged)

From the NexentaEdge deployment workstation, use the following command to deploy the NexentaEdge software to the nodes:

```
nedeploy deploy solo <ip-address> <nodename> <username:password> -i <interface>
    [-t <profile>][-x <disks-to-exclude>][-X <disks-to-reserve>][-z <zone>][-F <filesytem-type>][-m]
    [--docker][--P <number-of-partitions>][--upgrade]
```

Ensure that options "--docker" and "--upgrade" both specified.

Optionally, use option "--wipeout-datastores" (WARNING: all data will be wiped out!) to automatically re-initialize data stores.

Consult with "Upgrading NexentaEdge" section in [Installation Guide](https://nexenta.com/sites/default/files/docs/ReleaseNotes/NEdge-1.1.0-FP3-IG_20160629.pdf)
