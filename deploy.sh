#!/bin/bash

set -e

while getopts v:n:e: flag
do
    case "${flag}" in
        v) VERSION=${OPTARG};;
        n) NAMESPACE=${OPTARG};;
        e) ENVIRONMENT=${OPTARG};;
    esac
done

ACCOUNT="antonovichvladimir"
REPOSITORY="nginx-test1"
# VERSION="v.0.3"
# NAMESPACE="test1"
# ENVIRONMENT="dev"

pushd $(pwd)
cd nginx
# docker login ... # I expect the login procedure has done

echo "Build the image"
docker build -t ${ACCOUNT}/${REPOSITORY}:latest -t ${ACCOUNT}/${REPOSITORY}:${VERSION} .

echo "Push the image"
docker image push -a ${ACCOUNT}/${REPOSITORY}:latest
docker image push -a ${ACCOUNT}/${REPOSITORY}:${VERSION}
popd

echo "Create a deployment on k8s"
pushd $(pwd)

cd k8s
# create namespace, configmap and deployment
kubectl create namespace $NAMESPACE
kubectl apply -f $ENVIRONMENT/configmap.yaml -n $NAMESPACE
kubectl apply -f deployment.yaml -n $NAMESPACE
kubectl apply -f service.yaml -n $NAMESPACE
popd

echo "Waiting available pods..."
while [ $(kubectl get deployments -n test2 -o json | jq -r '.items[0].status.availableReplicas') != 1 ];
do
        sleep 2
done

#get status
echo "Deployment status:"
kubectl get deployments -n $NAMESPACE -o wide

echo "Pods:"
kubectl get pods -n $NAMESPACE

echo "Services:"
kubectl get service -n $NAMESPACE


IP=$(kubectl get service/test1-service -n $NAMESPACE -o json | jq -r '.status.loadBalancer.ingress[0].ip')

echo "Health status: $(curl -s http://$IP/health)"
echo "Message: $(curl -s http://$IP/message)"
