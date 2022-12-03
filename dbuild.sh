#!/bin/bash


docker build --rm=true -t ual-jupyter-test:latest -f dockerfiles/jupyter-testing/Dockerfile . || exit 1
docker system prune
