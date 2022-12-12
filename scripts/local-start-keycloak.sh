#!/bin/bash

export KEYCLOAK_ADMIN=admin
export KEYCLOAK_ADMIN_PASSWORD=admin
export KEYCLOAK_PORT="8080:8080"
export KEYCLOAK_IMAGE="quay.io/keycloak/keycloak:20.0.1"
export KEYCLOAK_MODE="start-dev"
export SOURCE_VOLUME=$(pwd)
export DESTINATION_VOLUME=tmp
export KEYCLOAK_URL=http://localhost:8080

# **************** Global variables

# **********************************************************************************
# Functions definition
# **********************************************************************************

function startKeycloak () {
    docker run -it -e KEYCLOAK_ADMIN=$KEYCLOAK_ADMIN \
                   -e KEYCLOAK_ADMIN_PASSWORD=$KEYCLOAK_ADMIN_PASSWORD \
                   -p $KEYCLOAK_PORT $KEYCLOAK_IMAGE $KEYCLOAK_MODE \ 
                   -v $SOURCE_VOLUME:$DESTINATION_VOLUME 
}

#**********************************************************************************
# Execution
# **********************************************************************************

startKeycloak