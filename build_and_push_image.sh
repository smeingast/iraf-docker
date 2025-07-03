#!/bin/bash

# Your Docker Hub username
dockerhub_username="smeingast"

# The name of the Docker image
image_name="iraf"

# The image tag
image_tag="2.17.1"

# Full Docker Hub image name
dockerhub_image="${dockerhub_username}/${image_name}:${image_tag}"

# Create a new builder which gives access to new multi-architecture features
docker buildx create --name mybuilder --use

# You need to run this command to do cross-compilation
docker buildx inspect --bootstrap 

# Build the Docker image using buildx
docker buildx build --platform linux/amd64,linux/arm64 --tag $dockerhub_image . --push

# List the Docker images for your username
docker image ls "${dockerhub_username}/${image_name}"
