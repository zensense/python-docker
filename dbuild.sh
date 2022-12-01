#!/bin/bash


docker system prune -a
docker build --rm=true -t ual-jupyter-test:latest -f jupyter/Dockerfile . || exit 1
