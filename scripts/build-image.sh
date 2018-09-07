#!/bin/bash
set -e
target=docker/
image=haskell-vim
if [[ $(git --no-pager diff HEAD~1..HEAD "$target") ]]; then
    echo "Changes detected in $target"
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
    cd docker
    echo "Build docker image"
    docker build -t "$image" .
    echo "Tag image"
    docker tag haskell-vim "$DOCKER_USERNAME/$image"
    echo "Push to docker hub"
    docker push "$DOCKER_USERNAME/$image"
else
    echo "No file changed in ${target}, skip build"
fi
