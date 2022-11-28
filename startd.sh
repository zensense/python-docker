#!/bin/bash

# the volume mount preserves data
# change package requirements for different packages by adding them to the Pipfile
# then rebuild the image by running this script

result=$(docker inspect -f '{{.Config.Image}}' jupyter-testing 2>/dev/null)
if [[ -n "$result" ]]; then
    echo -e "Stopping and rebuilding the container....\n\n"
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
    docker image prune -af
else
    echo -e "No container running, building a new one....\n\n"
fi

docker build --rm=true -t ual-jupyter-test:latest -f jupyter/Dockerfile . || exit 1

# Initial build may take a few minutes and hundreds of MB of downloads
env GID=$(id -g) UID=$(id -u) \
docker run --rm \
    --user root \
    -e UID=${UID} \
    -e GID=${GID} \
    --publish 127.0.0.1:8888:8888 \
    --publish 127.0.0.1:8080:8080 \
    --name "jupyter-testing" \
    -v "$(pwd)/notebooks:/usr/src/notebooks" \
    -v /run/host-services/ssh-auth.sock:/ssh-agent \
    -e SSH_AUTH_SOCK="/ssh-agent" \
    ual-jupyter-test:latest
