#!/usr/bin/env bash

set -euo pipefail

imagename=rene2/modernutils:buster

opt_test=
opt_buildx=

for i ; do
    case $i in
        -t|--test)
            opt_test=1
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
                     --progress plain \
                     --tag testimage \
                     --file ${dockerfile} \
                     . 2>&1 | grep '@ '
        docker image rm testimage 2>&1 >/dev/null || true
        echo
    }
    run_test debian:buster
    run_test debian:bookworm
    run_test ubuntu:focal
    exit 0
fi

if [[ $opt_buildx ]]; then
    # docker buildx rm buildx-local 2>&1 >/dev/null || true
    docker buildx create --use --name buildx-local || true
    docker buildx build --pull \
                        --platform linux/amd64,linux/arm64 \
                        --tag ${imagename} \
                        --push \
                        .
    # docker buildx rm buildx-local
    docker manifest inspect ${imagename} | jq -r '.manifests[] | (.platform.architecture + " " + .digest)'
else
    docker build --tag ${imagename} .
fi
