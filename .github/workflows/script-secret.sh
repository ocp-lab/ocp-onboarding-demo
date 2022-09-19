#!/bin/bash

docker_user=$1
docker_password=$2
namespace=$3

deploy=`oc get secret ghcr-secret`
if [[ "$?" -eq 0 ]]; then
    oc secrets unlink default ghcr-secret
    oc delete secrets ghcr-secret
fi
oc create secret docker-registry ghcr-secret --docker-server=ghcr.io --docker-username=$docker_user --docker-password=$docker_password $image -n $namespace
oc secrets link default ghcr-secret --for=pull -n ${{ env.OPENSHIFT_NAMESPACE }}
