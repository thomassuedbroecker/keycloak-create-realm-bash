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

function configureKeycloak() {
    echo "************************************"
    echo " Configure Keycloak realm"
    echo "************************************"

    # Set the needed parameter
    USER=admin
    PASSWORD=admin
    GRANT_TYPE=password
    CLIENT_ID=admin-cli
    EXAMPLE_REALM=../example-realm/example-realm.json

    access_token=$( curl -d "client_id=$CLIENT_ID" -d "username=$USER" -d "password=$PASSWORD" -d "grant_type=$GRANT_TYPE" "$KEYCLOAK_URL/realms/master/protocol/openid-connect/token" | sed -n 's|.*"access_token":"\([^"]*\)".*|\1|p')

    echo "Access token : $access_token"

    if [ "$access_token" = "" ]; then
        echo "------------------------------------------------------------------------"
        echo "Error:"
        echo "======"
        echo ""
        echo "It seems there is a problem to get the Keycloak access token: ($access_token)"
        echo "The script exits here!"
        echo ""
        echo "------------------------------------------------------------------------"
        exit 1
    fi

    # Create the realm in Keycloak
    echo "------------------------------------------------------------------------"
    echo "Create the realm in Keycloak"
    echo "------------------------------------------------------------------------"
    echo ""

    result=$(curl -d @"$EXAMPLE_REALM" -H "Content-Type: application/json" -H "Authorization: bearer $access_token" "$KEYCLOAK_URL/admin/realms")

    if [ "$result" = "" ]; then
        echo "------------------------------------------------------------------------"
        echo "The realm is created. "
        echo "Open following link in your browser:"
        echo "$KEYCLOAK_URL/admin/master/console/#/example-realm"
        echo "------------------------------------------------------------------------"
    else
        echo "------------------------------------------------------------------------"
        echo "Error:"
        echo "======"
        echo "It seems there is a problem with the realm creation: $result"
        echo "The script exits here!"
        echo ""
        exit 1
    fi
}

#**********************************************************************************
# Execution
# **********************************************************************************

configureKeycloak