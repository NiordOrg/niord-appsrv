#!/bin/bash

pushd `dirname ${BASH_SOURCE}` > /dev/null
export WILDFLY_CONF_DIR=`pwd`
popd > /dev/null

export WILDFLY_VERSION=10.0.0.Final
export WILDFLY=wildfly-$WILDFLY_VERSION
export WILDFLY_ROOT=$WILDFLY_CONF_DIR/..
export WILDFLY_PATH=$WILDFLY_ROOT/$WILDFLY

