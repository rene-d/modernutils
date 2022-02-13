#!/usr/bin/env bash

set -euo pipefail

builder=centos7

if [[ ${1-} == -t ]]; then
    run_test() {
        echo -e "Running checks on \033[93m$1\033[0m"
        docker build --target test --build-arg RANDOM=${RANDOM} --build-arg BASETEST=$1 --build-arg BUILDER=${builder} --progress plain --tag modernutilstests . 2>&1 | grep '@ ' 
        docker image rm modernutilstests 2>>/dev/null >/dev/null || true
        echo
    }
    run_test centos:7
    run_test centos:8
    run_test debian:buster
    run_test debian:bullseye
    exit 0
fi

docker build --build-arg BUILDER=${builder} --tag rene2/modernutils .
