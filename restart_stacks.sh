#!/bin/bash
DOCKER_ROOT="/srv/docker"

# stack directories
SUB_DIRS=(
    "uptime-kuma"
    "homepage"
    "ghost"
    "speedtest-tracker"
    "it-tools"
    "adguard"
    "metabase"
    "analysisworker-1"
    "rabbitmq"
    "bookstack"
    "gitea"
)

SUB_DIRS+=("nginx-proxy-manager")  # append this at the end to ensure it stays last

# directories to not fully stop the container
SKIP_STOP_DIRS=("nginx-proxy-manager" "adguard" "gitea")

# stop all stacks
for SUB_DIR in "${SUB_DIRS[@]}"; do
    if [[ " ${SKIP_STOP_DIRS[*]} " =~ " ${SUB_DIR} " ]]; then
        echo "skipping ${SUB_DIR}"
        continue
    fi

    echo "stopping ${SUB_DIR}"
    cd "${DOCKER_ROOT}/${SUB_DIR}" || {
        echo "Failed to change to ${SUB_DIR} directory"
        exit 1
    }
    sudo docker compose down
done

cd "${DOCKER_ROOT}"
sudo bash create_networks.sh

# restart stacks in reverse order they were stopped
for ((i=${#SUB_DIRS[@]}-1; i>=0; i--)); do
    SUB_DIR="${SUB_DIRS[i]}"
    echo "starting ${SUB_DIR}"
    cd "${DOCKER_ROOT}/${SUB_DIR}" || {
        echo "Failed to change to ${SUB_DIR} directory"
        exit 1
    }
    sudo docker compose up -d
done
