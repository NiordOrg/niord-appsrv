#!/bin/bash

#
# Starts keycloak and imports the "niord" realm
#

# Set up the wildfly env
DIR=`dirname $0`
source $DIR/../02-wildfly/wildfly-env.sh

REALM_FILE=$DIR/niord-dev-realm.json
REALM_RESULT_FILE=/tmp/niord-realm.json

# Check if a realm file has been specified
if [ -f "$1" ]
then
   REALM_FILE="$1"
fi

# Check if we need to replace localhost:8080 with another string
if [ -z "$2" ]
then
   cp $REALM_FILE  $REALM_RESULT_FILE
else
   echo "Replacing 'localhost:8080' with '$2'"
   sed 's/localhost:8080/'$2'/g' $REALM_FILE > $REALM_RESULT_FILE
fi

echo "*************************************************"
echo "* Starting Keycloak - importing $REALM_FILE     *"
echo "* When started, stop it again using Ctrl-C      *"
echo "*************************************************"
$WILDFLY_PATH/bin/standalone.sh \
   -Dkeycloak.migration.action=import \
   -Dkeycloak.migration.provider=singleFile \
   -Dkeycloak.migration.file=$REALM_RESULT_FILE \
   -Dkeycloak.migration.strategy=OVERWRITE_EXISTING


