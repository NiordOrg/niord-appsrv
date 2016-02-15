#!/bin/bash

# Set up the wildfly env 
DIR=`dirname $0`
source $DIR/wildfly-env.sh
source $DIR/../03-keycloak/keycloak-env.sh

KEYCLOAK_ADAPTER=keycloak-wildfly-adapter-dist-$KEYCLOAK_VERSION

echo "Installing Keycloak Wildfly adapter."
pushd $WILDFLY_PATH > /dev/null
curl -o $KEYCLOAK_ADAPTER.zip http://downloads.jboss.org/keycloak/$KEYCLOAK_VERSION/adapters/keycloak-oidc/$KEYCLOAK_ADAPTER.zip
unzip -o $KEYCLOAK_ADAPTER.zip
rm $KEYCLOAK_ADAPTER.zip

# Fix the adapter-install.cli script so that it runs the embedded server
echo "embed-server --server-config=standalone.xml"|cat - bin/adapter-install.cli > /tmp/keycloak && mv /tmp/keycloak bin/adapter-install.cli

# Apply the Wildfly updates
bin/jboss-cli.sh --file=bin/adapter-install.cli

popd > /dev/null
