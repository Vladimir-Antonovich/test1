#!/bin/bash

set -e

while getopts a:r:v:n:e: flag
do
    case "${flag}" in
        a) ACCOUNT=${OPTARG};;
        r) REPOSITORY=${OPTARG};;
        v) VERSION=${OPTARG};;
        n) NAMESPACE=${OPTARG};;
        e) ENVIRONMENT=${OPTARG};;
    esac
done

# ACCOUNT="antonovichvladimir"
# REPOSITORY="nginx-test1"
# VERSION="v.0.3"

# NAMESPACE="test1"
# ENVIRONMENT="dev"

cd nginx
# docker login ... # I expect the login procedure has done

echo "Build an image"
docker build -t ${ACCOUNT}/${REPOSITORY}:latest -t ${ACCOUNT}/${REPOSITORY}:${VERSION} .

echo "Push the image"
docker image push -a ${ACCOUNT}/${REPOSITORY}:latest
docker image push -a ${ACCOUNT}/${REPOSITORY}:${VERSION}

echo "Create a deployment on k8s"

cd ../k8s
# create namespace, configmap and deployment
kubectl create namespace $NAMESPACE
kubectl apply -f ./k8s/$ENVIRONMENT/configmap.yaml -n $NAMESPACE
kubectl apply -f ./k8s/deployment.yaml -n $NAMESPACE
kubectl apply -f ./k8s/service.yaml -n $NAMESPACE

#get status
echo "Deployment status:"
kubectl get deployments -n $NAMESPACE -o wide

echo "Pods:"
kubectl get pods -n $NAMESPACE

echo "Services:"
kubectl get service -n $NAMESPACE


IP=$(kubectl get service/test1-service -n $NAMESPACE -o json | jq -r '.status.loadBalancer.ingress[0].ip)

echo "Health status: $(curl http://$IP/health)"
echo "Message: $(curl http://$IP/message)"

