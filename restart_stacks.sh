#!/bin/bash
DOCKER_ROOT="/srv/docker"

# stack directories; keep reverse proxy last!
SUB_DIRS=("ghost" "speedtest-tracker" "it-tools" "portainer" "nginx-proxy-manager")

# stop all stacks
for SUB_DIR in "${SUB_DIRS[@]}"; do
    echo "stopping ${SUB_DIR}"
    cd "${DOCKER_ROOT}/${SUB_DIR}" || {
        echo "Failed to change to ${SUB_DIR} directory"
        exit 1
    }
    sudo docker compose down
done

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
