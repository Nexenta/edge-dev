Supported versions: 2.1.3-FP1+.

*** Quick architectural overview.
======================

NexentaEdge ccow-daemon collects statistcs in format compatible with StatsD "push" and sends it to a local audit daemon. Local audit daemon aggregates all the statistics from the local daemon (or daemons in case of multi data container deployments). This way each data node in the cluster does preliminary aggregation of local statistics and shares it with distributed hash database via corosync ring. Statistics is now globally available on each data node in fully consistent way.

Designated management server (aggregator) additionally exposing post-filtered metrics in format compatible with Prometheus "pull" model. It listens on port 8881 by default and that can be controlled via /opt/nedge/nmf/etc/config/prometheus-exporter.js configuration file. To verify if metrics works, run the following command on aggregator node (or use proper IP address in case of Docker / K8s deployment):

curl localhost:8881/metrics

Prometheus service periodically scrapes this URL and pulls statistics into its own time series database.

Grafana dashboard configured with Prometheus data source and displays metrics in a nice presentable way.

Additionally Prometheus can be configured with alerts and this can be done via Grafana interface.

Configuration.
===========

1. Install Prometheus with the command:

docker run -d -p 9090:9090 -v /etc/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus

make sure to add nexentaedge target to scrape config in /etc/prometheus.yml. /etc/prometheus as a default config works fine.

...
scrape_configs:
  - job_name: 'nexentaedge'
    static_configs:
      - targets: ['10.3.30.75:8881']
...

2. Install Grafana and nexentaedge dashboard:

docker run -d --name=grafana -p 3100:3000 grafana/grafana

Then login via port 3100 and set prometheus URL pointing to port 9090.

Import nexentaedge dashboard via json file (attached current snapshot) and observe that statistics now displaying correctly.
You can notice that some per-tenant statistics displayed as "instant" metric and that would require some I/O in terms of to see gauges moving.
In the example below Oscar running some read I/O and counters tells us more insightful information:

