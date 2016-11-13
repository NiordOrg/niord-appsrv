#!/bin/bash

# Set up the wildfly env 
DIR=`dirname $0`
source $DIR/keycloak-env.sh
source $DIR/../02-wildfly/wildfly-env.sh

KEYCLOAK_OVERLAY=keycloak-overlay-$KEYCLOAK_VERSION
TEMP_KEYCLOAK_OVERLAY_PATH=/tmp/$KEYCLOAK_OVERLAY.zip


echo "Installing Keycloak overlay in Wildfly installation."
pushd $WILDFLY_PATH > /dev/null

# Since downloads.jboss.org can be APPALLINGLY slow, keep a copy in /tmp
if [ ! -f "$TEMP_KEYCLOAK_OVERLAY_PATH" ]
then
    curl -o $TEMP_KEYCLOAK_OVERLAY_PATH https://downloads.jboss.org/keycloak/$KEYCLOAK_VERSION/$KEYCLOAK_OVERLAY.zip
fi
cp $TEMP_KEYCLOAK_OVERLAY_PATH $KEYCLOAK_OVERLAY.zip
unzip -o $KEYCLOAK_OVERLAY.zip
rm $KEYCLOAK_OVERLAY.zip

echo "Installing Niord login theme"
cp -r $KEYCLOAK_CONF_DIR/theme/niord themes/

# Configure Keycloak:
echo "Configuring Keycloak overlay."
pushd $WILDFLY_PATH/bin > /dev/null
$WILDFLY_PATH/bin/jboss-cli.sh --file=keycloak-install.cli

# Replace the default H2 database with a MySQL database
$WILDFLY_PATH/bin/jboss-cli.sh <<EOF
# Start offline server
embed-server --server-config=standalone.xml

# Remove existing data source
data-source remove --name=KeycloakDS

# Add Keycloak Datasource
data-source add \
  --name=KeycloakDS \
  --driver-name=mysql \
  --jndi-name=java:jboss/datasources/KeycloakDS \
  --connection-url="jdbc:mysql://\${env.KCDB_PORT_3306_TCP_ADDR:localhost}:\${env.KCDB_PORT_3306_TCP_PORT:3306}/\${env.KCDB_DATABASE:niordkc}?useSSL=false&amp;useUnicode=true&amp;characterEncoding=UTF-8" \
  --user-name=\${env.KCDB_USERNAME:niordkc} \
  --password=\${env.KCDB_PASSWORD:niordkc} \
  --use-ccm=true \
  --min-pool-size=10 \
  --max-pool-size=100 \
  --blocking-timeout-wait-millis=5000 \
  --enabled=true \
  --check-valid-connection-sql="SELECT 1" \
  --background-validation=true \
  --background-validation-millis=60000

stop-embedded-server
EOF

popd > /dev/null
popd > /dev/null

