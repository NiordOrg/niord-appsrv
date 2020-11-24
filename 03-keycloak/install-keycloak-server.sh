#!/bin/bash

#
# Installs a Keycloak server
#

# Set up the Keycloak env
DIR=`dirname $0`
source $DIR/keycloak-env.sh


# NB: We could download from JBoss, but using maven makes it faster because it is fetched from local maven repo...
echo "Installing $KEYCLOAK to $KEYCLOAK_ROOT"
rm -rf $KEYCLOAK_PATH
mvn package -f $DIR/install-keycloak-server-pom.xml -P install-keycloak-server -DskipTests
rm -rf  $DIR/target

chmod +x $KEYCLOAK_PATH/bin/*.sh

echo "Installing Niord login theme"
cp -r $KEYCLOAK_CONF_DIR/theme/niord $KEYCLOAK_PATH/themes/


MYSQL_DRIVER_VERSION=8.0.22
#5.1.39
MYSQL_DRIVER=mysql-connector-java-$MYSQL_DRIVER_VERSION.jar

echo "Installing MySQL driver."
curl -o $MYSQL_DRIVER https://repo1.maven.org/maven2/mysql/mysql-connector-java/$MYSQL_DRIVER_VERSION/$MYSQL_DRIVER

# We want to configure Keycloak support HTTPS and to use MySQL, not the default H2.
echo "Configuring Keycloak server."
$KEYCLOAK_PATH/bin/jboss-cli.sh <<EOF
# Start offline server
embed-server --server-config=standalone.xml

# Add mysql module
module add \
  --name=com.mysql \
  --resources=$MYSQL_DRIVER \
  --dependencies=javax.api,javax.transaction.api
  	
# Add mysql driver
/subsystem=datasources/jdbc-driver=mysql:add(driver-name=mysql,driver-module-name=com.mysql,driver-class-name=com.mysql.jdbc.Driver)

# Configure HTTPS
/socket-binding-group=standard-sockets/socket-binding=proxy-https:add(port=443)
/subsystem=undertow/server=default-server/http-listener=default:write-attribute(name=proxy-address-forwarding,value=true)
/subsystem=undertow/server=default-server/http-listener=default:write-attribute(name=redirect-socket,value=proxy-https)

/subsystem=transactions:write-attribute(name=node-identifier,value=NiordKC)

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

rm -f $MYSQL_DRIVER
