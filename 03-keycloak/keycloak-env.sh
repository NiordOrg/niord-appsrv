#!/bin/bash

pushd `dirname ${BASH_SOURCE}` > /dev/null
export KEYCLOAK_CONF_DIR=`pwd`
popd > /dev/null

export KEYCLOAK_VERSION=2.1.0.Final

