#!/bin/bash

pushd `dirname ${BASH_SOURCE}` > /dev/null
export KEYCLOAK_CONF_DIR=`pwd`
popd > /dev/null

export KEYCLOAK_VERSION=2.4.0.Final
export KEYCLOAK=keycloak-$KEYCLOAK_VERSION
export KEYCLOAK_ROOT=$KEYCLOAK_CONF_DIR/..
export KEYCLOAK_PATH=$KEYCLOAK_ROOT/$KEYCLOAK

