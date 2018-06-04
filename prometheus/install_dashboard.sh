#!/usr/bin/env bash
#
# Install and Configure Prometheus and Grafana for NexentaEdge monitoring
#
# Downloads and installs Docker containers for Prometheus and Grafana.
# Configures the containers to monitor NexentaEdge on the provided IP
# and provide a monitoring dashboard using Grafana
#
# This script is designed to be executed directly on the NexentaEdge 
# management server, or it needs to be provided the IP of the management server
#

MGMTIP=${1:-"127.0.0.1"}
PASSWORD="nexenta"  # Default password for Grafana 'admin' user

# 
DASHBOARD_DIR=${2:-"/opt/nedge/dashboard"}
P_CONTAINER=prom/prometheus:v2.2.1
G_CONTAINER=grafana/grafana:5.1.3
METRICPORT=8881 # Port that runs Prometheus stats plugin on $MGMTIP

die() {
  printf '%s\n' "$1" >&2
  exit 1
}

echo "Using NexentaEdge Management server on ip: $MGMTIP"
echo " "

which docker 2>&1 > /dev/null || die "ERROR: Docker not installed"
which curl 2>&1 > /dev/null || die "ERROR: curl not installed"

echo "Pulling Docker container for Prometheus: $P_CONTAINER"
docker pull $P_CONTAINER
echo " "

echo "Pulling Docker container for Grafana: $G_CONTAINER"
docker pull $G_CONTAINER
echo " "

echo "Downloading Prometheus configuration files from GitHub into $DASHBOARD_DIR"
mkdir -p $DASHBOARD_DIR/prometheus \
         $DASHBOARD_DIR/grafana/provisioning/{dashboards,datasources} || \
		 die "ERROR: Unable to create $DASHBOARD_DIR"

# Save example config file, and update the IP to point to MGMTIP:PORT
curl -s https://raw.githubusercontent.com/Nexenta/edge-dev/install-p_g/prometheus/prometheus.yml | \
  sed -e "s/targets: \['172.20.1.20:8881'\]/targets: \['$MGMTIP:$METRICPORT'\]/g" > $DASHBOARD_DIR/prometheus/prometheus.yml

echo "Starting Prometheus container"
n=$(docker ps -a --filter name="prometheus" |wc -l 2>&1)
if [ $n -gt 1 ] ; then
  die "ERROR: Prometheus container already exists"
fi

docker run -d --restart=always -p 9090:9090 --name="prometheus" \
  -v $DASHBOARD_DIR/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
  $P_CONTAINER || die "ERROR: Unable to start Docker container for Prometheus"

# Grab the IP the container got assigned
P_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' prometheus)
echo " "
echo " "

echo "Downloading Grafana configuration files from GitHub into $DASHBOARD_DIR"
curl -s https://raw.githubusercontent.com/Nexenta/edge-dev/install-p_g/prometheus/NexentaEdge-Grafana-v1.0.json > \
  $DASHBOARD_DIR/grafana/provisioning/dashboards/NexentaEdge.json
curl -s https://raw.githubusercontent.com/Nexenta/edge-dev/install-p_g/prometheus/grafana/NexentaEdge.yml > \
  $DASHBOARD_DIR/grafana/provisioning/dashboards/NexentaEdge.yml
curl -s https://raw.githubusercontent.com/Nexenta/edge-dev/install-p_g/prometheus/grafana/prometheus.yml > \
  $DASHBOARD_DIR/grafana/provisioning/datasources/prometheus.yml

sed -i -e 's/${DS_PROMETHEUS}/Prometheus/g' $DASHBOARD_DIR/grafana/provisioning/dashboards/NexentaEdge.json
sed -i -e "s/PROMETHEUS_IP:PROMETHEUS_PORT/$P_IP:9090/g" $DASHBOARD_DIR/grafana/provisioning/datasources/prometheus.yml

echo "Starting Grafana container"
#  -v $DASHDIR/grafana/grafana.ini:/etc/grafana/grafana.ini \
docker run -d --restart=always --name="grafana" -p 3001:3000 \
    -v $DASHBOARD_DIR/grafana/provisioning/datasources/prometheus.yml:/etc/grafana/provisioning/datasources/prometheus.yml \
    -v $DASHBOARD_DIR/grafana/provisioning/dashboards/NexentaEdge.json:/etc/grafana/provisioning/dashboards/NexentaEdge.json \
    -v $DASHBOARD_DIR/grafana/provisioning/dashboards/NexentaEdge.yml:/etc/grafana/provisioning/dashboards/NexentaEdge.yml \
  $G_CONTAINER || die "ERROR: Unable to start Docker container for Grafana"
echo " "

echo "Waiting 10s for Grafana to start before updating config"
sleep 10

echo "Changing password of Grafana"
echo "curl -sX PUT -H \"Content-Type: application/json\" --data-binary '{\"oldPassword\":\"admin\",\"newPassword\":\"$PASSWORD\",\"confirmNew\":\"$PASSWORD\"}' http://admin:admin@localhost:3000/api/user/password" |\
  docker exec -i grafana bash -
echo " "

echo "Changing default dashboard to NexentaEdge"
echo "curl -sX POST -H \"Content-Type: application/json\" http://admin:$PASSWORD@localhost:3000/api/user/stars/dashboard/1" |\
  docker exec -i grafana bash -

echo "curl -sX PUT -H \"Content-Type: application/json\" --data-binary '{\"theme\":\"\",\"timezone\":\"\",\"homeDashboardId\":1}' http://admin:$PASSWORD@localhost:3000/api/org/preferences" |\
  docker exec -i grafana bash -
#echo "curl -sX PUT -H \"Content-Type: application/json\" --data-binary '{\"theme\":\"\",\"timezone\":\"\",\"homeDashboardId\":1}' http://admin:$PASSWORD@localhost:3000/api/user/preferences" |\
#  docker exec -i grafana bash -
echo " "

echo " "
echo "Prometheus listening on port 9090, and running on Docker IP http://$P_IP:9090"
echo "Grafana Dashboard on http://0.0.0.0:3001 admin/$PASSWORD"
exit 0
