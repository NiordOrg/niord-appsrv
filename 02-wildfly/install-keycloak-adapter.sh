#!/bin/bash

# Set up the wildfly env 
DIR=`dirname $0`
source $DIR/wildfly-env.sh
source $DIR/../03-keycloak/keycloak-env.sh

KEYCLOAK_ADAPTER=keycloak-wildfly-adapter-dist-$KEYCLOAK_VERSION

echo "Installing Keycloak Wildfly adapter."
pushd $WILDFLY_PATH > /dev/null
curl -o $KEYCLOAK_ADAPTER.zip https://downloads.jboss.org/keycloak/$KEYCLOAK_VERSION/adapters/keycloak-oidc/$KEYCLOAK_ADAPTER.zip

unzip -o $KEYCLOAK_ADAPTER.zip
rm $KEYCLOAK_ADAPTER.zip

# Apply the Wildfly updates
bin/jboss-cli.sh --file=bin/adapter-install-offline.cli

popd > /dev/null
