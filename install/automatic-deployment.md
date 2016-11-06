## Fully Automatic deployment of NexentaEdge Container-Converged environment
This procedure describes Enterprise grade mechanism to deploy Containers for production usage. Deployment is pre-checking environment and ensures that destination target meets requirements. It also sets most optimal configuration and provides a way to select profile whie deploying.

### Step 1: Install NEDEPLOY management tool
NexentaEdge defines set of well described Chef Cookbooks which provides easy way to deploy complex cluster infrastructure excluding possible human error.

To enable NEDEPLOY tool set the following or similar alias:
```
alias nedeploy="docker run --network host -it nexenta/nedge-nedeploy /opt/nedeploy/nedeploy"
```

### Step 2: Designing cluster network

TODO

### Step 3: Selecting most optimal operational profile

TODO

### Step 4: Deploying nodes across cluster

TODO
