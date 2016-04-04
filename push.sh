#!/bin/bash

if [ -z "${1}" ]; then
   version="latest"
else
   version="${1}"
fi


docker push adamcrow64/javamvn:"${version}"
docker tag -f adamcrow64/javamvn:"${version}"  adamcrow64/javamvn:latest
docker push adamcrow64/javamvn:latest

