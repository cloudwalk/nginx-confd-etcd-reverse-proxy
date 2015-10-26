#!/bin/bash

set -eo pipefail

export ETCD_PORT=${ETCD_PORT:-4001}
export HOST_IP=${HOST_IP:-172.17.42.1}
export ETCD=$HOST_IP:$ETCD_PORT

echo "[nginx] Booting container. ETCD: $ETCD."

# Try to make initial configuration every 5 seconds until successful
until confd -onetime -node $ETCD -config-file /etc/confd/conf.d/nginx.toml; do
    echo "[nginx] waiting for confd to create initial nginx configuration."
    sleep 5
done

echo "[nginx] Config file:"
cat /etc/nginx/nginx.conf

confd -interval 5 -node $ETCD -config-file /etc/confd/conf.d/nginx.toml &
echo "[nginx] confd is now monitoring etcd for changes in intervals of 5 seconds..."

# Start the Nginx service using the generated config
echo "[nginx] starting nginx service..."
exec nginx -g "daemon off;" &

# Follow the logs to allow the script to continue running
exec tail -f /var/log/nginx/*.log
