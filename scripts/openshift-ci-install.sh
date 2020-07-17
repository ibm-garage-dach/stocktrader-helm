#!/bin/bash

oc new-project stock-trader-ci

oc apply -f ci-pipeline.yaml

oc new-app \
    --template=stocktrader-build-pipeline \
    -p APP_NAME=portfolio \
    -p GIT_SOURCE_URL=https://github.com/IBMStockTrader/portfolio.git \
    -p GIT_SOURCE_REF=06fa8cf4d0b49c67ed962b371fa3fcb28767db8c

oc new-app \
    --template=stocktrader-build-pipeline \
    -p APP_NAME=stock-quote \
    -p GIT_SOURCE_URL=https://github.com/IBMStockTrader/stock-quote.git \
    -p GIT_SOURCE_REF=fca47c2859f3d18827e35a921022f00d55f222a9

oc new-app \
    --template= stocktrader-build-pipeline \
    -p APP_NAME=trader \
    -p GIT_SOURCE_URL=https://github.com/IBMStockTrader/trader.git \
    -p GIT_SOURCE_REF=7db5fcb2c6f07d0609eb38ca2139c0bf35a859d7

oc new-app \
    --template=stocktrader-build-pipeline \
    -p APP_NAME=tradr \
    -p GIT_SOURCE_URL=https://github.com/ibm-garage-dach/tradr.git \
    -p GIT_SOURCE_REF=master

oc new-app \
    --template=stocktrader-build-pipeline \
    -p APP_NAME=messaging \
    -p GIT_SOURCE_URL=https://github.com/ibm-garage-dach/messaging.git \
    -p GIT_SOURCE_REF=openshift-demo

oc new-app \
    --template=stocktrader-build-pipeline \
    -p APP_NAME=notification-slack \
    -p GIT_SOURCE_URL=https://github.com/ibm-garage-dach/notification-slack.git \
    -p GIT_SOURCE_REF=openshift-demo
