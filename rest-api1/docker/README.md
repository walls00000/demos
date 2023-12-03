# node-e2e

This directory contains files to publish the node-e2e docker image to ecr or dockerhub

## ECR Setup

export AWS_PROFILE=<your-aws-profile>

### Build

```
source ./build-ecr.sh
build
create-repo  # one time only
push
pull
list-images
```

## Dockerhub Setup

```
source ./build-docker-repo.sh; build; login; push; pull
```
