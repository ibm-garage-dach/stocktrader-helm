#!/bin/bash


# Create new project & allow access to image streams

oc new-project stock-trader-helm

oc policy add-role-to-user \
    system:image-puller system:serviceaccount:stock-trader-helm:default \
    --namespace=stock-trader-ci


# Install Redis

oc new-app \
    --template redis-ephemeral \
    -p DATABASE_SERVICE_NAME=redis-trader \
    -p REDIS_PASSWORD=admin


# Install MQ

oc create secret generic mq-trader1-secret \
    --from-literal=adminPassword=mq1pw 

helm repo add ibm-stable-charts https://raw.githubusercontent.com/IBM/charts/master/repo/stable

helm install \
    mq-trader1 \
    ibm-stable-charts/ibm-mqadvanced-server-dev \
    --set license=accept \
    --set queueManager.name=stocktrader \
    --set queueManager.dev.secret.name=mq-trader1-secret \
    --set queueManager.dev.secret.adminPasswordKey=adminPassword

oc rsh mq-trader1-ibm-mq-0
    runmqsc
    DEFINE QLOCAL ('NotificationQ') DEFPSIST(YES)
    SET AUTHREC PROFILE('NotificationQ') OBJTYPE(QUEUE) PRINCIPAL('app') AUTHADD(BROWSE,GET,INQ,PUT)
    exit
    exit


# Install app with Helm

helm install \
    demo \
    ./stocktrader \
    -f custom-values.yaml


# Update app with Helm

helm upgrade \
    demo \
    ./stocktrader \
    -f custom-values.yaml
