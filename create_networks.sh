#!/bin/bash

NETWORKS=(
    "proxy-bridge"
    "analysisworker-network"
    "bookstack-network"
    "ghost-network"
    "gitea-network"
    "homepage-network"
    "ittools-network"
    "metabase-network"
    "rabbitmq-network"
    "speedtest-network"
    "uptimekuma-network"
)

for network in "${NETWORKS[@]}"; do
    if ! sudo docker network inspect "$network" &>/dev/null; then
        sudo docker network create "$network"
        echo "Created network: $network"
    fi
done
