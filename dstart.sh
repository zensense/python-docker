#!/bin/bash


CONTAINER_NAME="jupyter-testing"
USER_NAME="docker"

result=$(docker inspect -f '{{.Config.Image}}' "${CONTAINER_NAME}" 2>/dev/null)
if [[ -n "$result" ]]; then
    echo -e "Stopping and restarting the container....\n\n"
    docker stop $(docker ps -a -q)
else
    echo -e "No container running, starting a new one....\n\n"
fi

# Initial build may take a few minutes (and hundreds of MB of downloads!)
env GID=$(id -g) UID=$(id -u) \
docker run --rm -i -t \
    --name "${CONTAINER_NAME}" \
    -e USER=${USER_NAME} \
    -e UID=${UID} \
    -e GID=${GID} \
    -p 127.0.0.1:8888:8888 \
    -p 127.0.0.1:8080:8080 \
    -v "$(pwd)/notebooks:/usr/src/notebooks" \
    -v /run/host-services/ssh-auth.sock:/ssh-agent \
    -e SSH_AUTH_SOCK="/ssh-agent" \
    -e SSH_DIR="/home/${USER_NAME}/.ssh" \
    --user ${USER_NAME} \
    ual-jupyter-test:latest

## TODO: secure notebook connection
## create vnc tunnel with another vnc container
## probs need a compose file to keep it all straight with network, etc.
#VNC_HOST="${CONTAINER_NAME}"
#VNC_PORT="8888"
#LOCAL_PORT="8889"
## vnc://localhost:${LOCAL_PORT} or whatever software accepts the VNC protocol
#ssh -N -f -L 127.0.0.1:$LOCAL_PORT:$VNC_HOST:$VNC_PORT ${VNC_USER}@$VNC_HOST sleep 60
