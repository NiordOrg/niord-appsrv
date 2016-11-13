#!/bin/bash

#
# Starts keycloak and exports the "niord" realm
#

# Set up the Keycloak env
DIR=`dirname $0`
source $DIR/keycloak-env.sh

REALM_NAME=niord
REALM_FILE=$DIR/niord-bootstrap-realm.json

# Check if a realm file has been specified
if [ -n "$1" ]
then
   REALM_FILE="$1"
fi

echo "*************************************************"
echo "* Starting Keycloak - exporting $REALM_FILE     *"
echo "* When started, stop it again using Ctrl-C      *"
echo "*************************************************"
$KEYCLOAK_PATH/bin/standalone.sh \
   -Dkeycloak.migration.action=export \
   -Dkeycloak.migration.provider=singleFile \
   -Dkeycloak.migration.file=$REALM_FILE \
   -Dkeycloak.migration.realmName=$REALM_NAME \
   -Dkeycloak.migration.usersExportStrategy=SKIP


popd > /dev/null


