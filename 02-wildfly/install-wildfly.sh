#!/bin/bash

#
# Installs a Wildfly instance and adds a MySQL driver
#

# Set up the wildfly env 
DIR=`dirname $0`
source $DIR/wildfly-env.sh


# NB: We could download from JBoss, but using maven makes it faster because it is fetched from local maven repo...
echo "Installing $WILDFLY to $WILDFLY_ROOT"
rm -rf $WILDFLY_PATH
mvn package -f $DIR/install-wildfly-pom.xml -P install-wildfly -DskipTests
rm -rf  $DIR/target

chmod +x $WILDFLY_PATH/bin/*.sh

# Install the MySQL driver
$WILDFLY_CONF_DIR/install-mysql-ds.sh

# Install the Hibernate Spatial module
$WILDFLY_CONF_DIR/install-hibernate-spatial.sh

# Install the Keycloak adapter
$WILDFLY_CONF_DIR/install-keycloak-adapter.sh

