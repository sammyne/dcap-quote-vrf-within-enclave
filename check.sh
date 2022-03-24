#!/bin/bash

set -e

hint() {
  echo ""
  echo "---"
  echo "$1 ..."
}

if [[ -z "$PCCS_ADDR" ]]; then
  echo "must specify PCCS_ADDR"
  exit 1
fi

qcnl_conf=/etc/sgx_default_qcnl.conf
echo "renewing PCCS_ADDR in $qcnl_conf"
sed -i "s|^PCCS_URL.*|PCCS_URL=https://$PCCS_ADDR/sgx/certification/v3/|g" $qcnl_conf
sed -i "s|^USE_SECURE.*|USE_SECURE_CERT=FALSE|g" $qcnl_conf

hint "start up the AESM"
nohup bash aesmd.sh &

hint "waiting for AESM being ready"
while [ "$(ps aux | grep 'aesm_service --no-daemon' | wc -l)" -ne 2 ]; do
  echo "  still waiting ..."
  sleep 2s
done
hint "AESM is now ready :)"

gramine-sgx hello-world
