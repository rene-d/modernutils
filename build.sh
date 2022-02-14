#!/usr/bin/env bash

set -euo pipefail

builder=centos7
dockerfile=Dockerfile
imagename=rene2/modernutils

opt_test=
opt_buildx=

for i ; do
    case $i in
        -t|--test)
            opt_test=1
            ;;
       figlet)
            dockerfile=Dockerfile-figlet
            imagename=rene2/figlet
            ;;
        -x)
            opt_buildx=1
            ;;
    esac
done

if [[ $opt_test ]]; then
    run_test() {
        echo -e "Running checks on \033[93m$1\033[0m"
        docker build --target test \
                     --build-arg RANDOM=${RANDOM} \
                     --build-arg BASETEST=$1 \
                     --build-arg BUILDER=${builder} \
                     --progress plain \
                     --tag testimage \
                     --file ${dockerfile} \
                     . 2>&1 | grep '@ '
        docker image rm testimage 2>&1 >/dev/null || true
        echo
    }
    run_test centos:7
    run_test centos:8
    run_test debian:buster
    run_test debian:bullseye
    run_test ubuntu:focal
    exit 0
fi

if [[ $opt_buildx ]]; then
    # docker buildx rm buildx-local 2>&1 >/dev/null || true
    docker buildx create --use --name buildx-local || true
    docker buildx build --pull \
                        --platform linux/amd64,linux/arm64 \
                        --build-arg BUILDER=${builder} \
                        --tag ${imagename} \
                        --file ${dockerfile} \
                        --push \
                        .
    # docker buildx rm buildx-local
    docker manifest inspect ${imagename} | jq -r '.manifests[] | (.platform.architecture + " " + .digest)'
else
    docker build --build-arg BUILDER=${builder} --tag ${imagename} --file ${dockerfile} .
fi
