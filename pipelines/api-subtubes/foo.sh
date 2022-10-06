#!/usr/bin/env bash 


IMAGE_TAG=build-$(echo "12345:escape" | awk -F ":" '{print $2}')
echo $IMAGE_TAG