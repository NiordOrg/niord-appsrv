#!/bin/bash

#
# Starts keycloak and imports the "niord" realm
#

# Set up the Keycloak env
DIR=`dirname $0`
source $DIR/keycloak-env.sh

REALM_FILE=$DIR/niord-bootstrap-realm.json

# Check if a realm file has been specified
if [ -f "$1" ]
then
   REALM_FILE="$1"
fi

echo "*************************************************"
echo "* Starting Keycloak - importing $REALM_FILE     *"
echo "* When started, stop it again using Ctrl-C      *"
echo "*************************************************"
$KEYCLOAK_PATH/bin/standalone.sh \
   -Dkeycloak.migration.action=import \
   -Dkeycloak.migration.provider=singleFile \
   -Dkeycloak.migration.file=$REALM_FILE \
   -Dkeycloak.migration.strategy=OVERWRITE_EXISTING


