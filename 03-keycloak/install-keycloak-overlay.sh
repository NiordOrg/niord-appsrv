#!/bin/bash

# Set up the wildfly env 
DIR=`dirname $0`
source $DIR/keycloak-env.sh
source $DIR/../02-wildfly/wildfly-env.sh

KEYCLOAK_OVERLAY=keycloak-overlay-$KEYCLOAK_VERSION


echo "Installing Keycloak overlay in Wildfly installation."
pushd $WILDFLY_PATH > /dev/null
curl -o $KEYCLOAK_OVERLAY.zip http://downloads.jboss.org/keycloak/$KEYCLOAK_VERSION/$KEYCLOAK_OVERLAY.zip
unzip -o $KEYCLOAK_OVERLAY.zip
rm $KEYCLOAK_OVERLAY.zip

# We want to configure Keycloak to use MySQL, not the default H2 you would get if you execute:
#bin/jboss-cli.sh --file=bin/keycloak-install.cli
$WILDFLY_PATH/bin/jboss-cli.sh <<EOF
# Start offline server
embed-server --server-config=standalone.xml

# Add Keycloak Datasource
data-source add \
  --name=KeycloakDS \
  --driver-name=mysql \
  --jndi-name=java:jboss/datasources/KeycloakDS \
  --connection-url="jdbc:mysql://\${env.KCDB_PORT_3306_TCP_ADDR:localhost}:\${env.KCDB_PORT_3306_TCP_PORT:3306}/\${env.KCDB_DATABASE:niordkc}?useSSL=false&amp;useUnicode=true&amp;characterEncoding=UTF-8" \
  --user-name=\${env.KCDB_USERNAME:niordkc} \
  --password=\${env.KCDB_PASSWORD:niordkc} \
  --use-ccm=false \
  --min-pool-size=10 \
  --max-pool-size=100 \
  --blocking-timeout-wait-millis=5000 \
  --enabled=true

# Add the remaining configuration from bin/keycloak-install.cli
/subsystem=infinispan/cache-container=keycloak:add(jndi-name="infinispan/Keycloak")
/subsystem=infinispan/cache-container=keycloak/local-cache=realms:add()
/subsystem=infinispan/cache-container=keycloak/local-cache=users:add()
/subsystem=infinispan/cache-container=keycloak/local-cache=sessions:add()
/subsystem=infinispan/cache-container=keycloak/local-cache=offlineSessions:add()
/subsystem=infinispan/cache-container=keycloak/local-cache=loginFailures:add()
/subsystem=infinispan/cache-container=keycloak/local-cache=work:add()
/subsystem=infinispan/cache-container=keycloak/local-cache=realmVersions:add()
/subsystem=infinispan/cache-container=keycloak/local-cache=realmVersions/transaction=TRANSACTION:add(mode=BATCH,locking=PESSIMISTIC)
/extension=org.keycloak.keycloak-server-subsystem/:add(module=org.keycloak.keycloak-server-subsystem)
/subsystem=keycloak-server:add(web-context=auth)

# Reload and stop offline server
reload --admin-only=false
stop-embedded-server
EOF

popd > /dev/null

