## Upgrade or re-installation
This guide will explain how to upgrade or re-install exisiting environment

### Upgrade

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

### Re-installation

Follow upgrade sequence and shutdown all the nodes.

For each device "name" key in your nesetup.json execute the following command on each node:

```
docker run --rm --privileged=true -v /dev:/dev nexenta/nedge /opt/nedge/sbin/nezap --do-as-i-say DEVID [JOURNAL_DEVID]
```

Make sure to zap all the devices you listed in nesetup.json. Use optional JOURNAL_DEVID parameter to additionally zap journal/cache SSD.

Re-run your regular starting sequence
