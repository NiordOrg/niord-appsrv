#!/bin/bash

# Set up the wildfly env 
DIR=`dirname $0`
source $DIR/wildfly-env.sh

MYSQL_DRIVER_VERSION=5.1.38
MYSQL_DRIVER=mysql-connector-java-$MYSQL_DRIVER_VERSION.jar


echo "Installing MySQL driver."
pushd $DIR > /dev/null
curl -o $MYSQL_DRIVER http://central.maven.org/maven2/mysql/mysql-connector-java/$MYSQL_DRIVER_VERSION/$MYSQL_DRIVER
$WILDFLY_PATH/bin/jboss-cli.sh <<EOF
# Start offline server
embed-server --std-out=echo

# Add mysql module
module add \
  --name=com.mysql \
  --resources=$MYSQL_DRIVER \
  --dependencies=javax.api,javax.transaction.api

# Add mysql driver
/subsystem=datasources/jdbc-driver=mysql:add(driver-name=mysql,driver-module-name=com.mysql,driver-class-name=com.mysql.jdbc.Driver)

# Add data source
data-source add \
  --name=niordDS \
  --jndi-name=java:jboss/datasources/niordDS \
  --driver-name=mysql \
  --connection-url="jdbc:mysql://\${env.NIORDDB_PORT_3306_TCP_ADDR:localhost}:\${env.NIORDDB_PORT_3306_TCP_PORT:3306}/\${env.NIORDDB_DATABASE:niord}?useSSL=false&amp;useUnicode=true&amp;characterEncoding=UTF-8" \
  --user-name=\${env.NIORDDB_USERNAME:niord} \
  --password=\${env.NIORDDB_PASSWORD:niord} \
  --transaction-isolation=TRANSACTION_READ_COMMITTED \
  --min-pool-size=10 \
  --max-pool-size=200 \
  --prepared-statements-cache-size=100 \
  --share-prepared-statements=true \
  --check-valid-connection-sql="SELECT 1" \
  --background-validation=true \
  --background-validation-millis=60000

# Reload and stop offline server
reload --admin-only=false
stop-embedded-server
EOF

rm -f $MYSQL_DRIVER
popd > /dev/null

