#!/bin/bash

if [ -z "${1}" ]; then
   version="latest"
else
   version="${1}"
fi

# Get latest Ubuntu 
docker pull ubuntu:16.04 
docker build --no-cache -t adamcrow64/javamvn:${version} .
