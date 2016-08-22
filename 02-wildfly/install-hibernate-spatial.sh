#!/bin/bash

# Set up the wildfly env 
DIR=`dirname $0`
source $DIR/wildfly-env.sh

HIBERNATE_MODULE=$WILDFLY_PATH/modules/system/layers/base/org/hibernate/main

HIBERNATE_VERSION=5.0.10.Final
HIBERNATE_SPATIAL=hibernate-spatial-$HIBERNATE_VERSION.jar
GEOLATTE_VERSION=1.0.5
GEOLATTE=geolatte-geom-$GEOLATTE_VERSION.jar
JTS_VERSION=1.14.0
JTS=jts-core-$JTS_VERSION.jar
JTS_IO_VERSION=1.14.0
JTS_IO=jts-io-$JTS_IO_VERSION.jar
JSON_SIMPLE_VERSION=1.1.1
JSON_SIMPLE=json-simple-$JSON_SIMPLE_VERSION.jar


echo "Updating Hibernate module. Make sure this is up-to-date with the current WILDFLY version!"
cat > $HIBERNATE_MODULE/module.xml << EOL
<?xml version="1.0" encoding="UTF-8"?>
<module xmlns="urn:jboss:module:1.3" name="org.hibernate">
    <resources>
        <resource-root path="hibernate-core-$HIBERNATE_VERSION.jar"/>
        <resource-root path="hibernate-envers-$HIBERNATE_VERSION.jar"/>
        <resource-root path="hibernate-entitymanager-$HIBERNATE_VERSION.jar"/>
        <resource-root path="hibernate-java8-$HIBERNATE_VERSION.jar"/>
        <resource-root path="$HIBERNATE_SPATIAL"/>
        <resource-root path="$GEOLATTE"/>
        <resource-root path="$JTS"/>
        <resource-root path="$JTS_IO"/>
        <resource-root path="$JSON_SIMPLE"/>
    </resources>

    <dependencies>
        <module name="asm.asm"/>
        <module name="com.fasterxml.classmate"/>
        <module name="javax.api"/>
        <module name="javax.annotation.api"/>
        <module name="javax.enterprise.api"/>
        <module name="javax.persistence.api"/>
        <module name="javax.transaction.api"/>
        <module name="javax.validation.api"/>
        <module name="javax.xml.bind.api"/>
        <module name="org.antlr"/>
        <module name="org.dom4j"/>
        <module name="org.javassist"/>
        <module name="org.jboss.as.jpa.spi"/>
        <module name="org.jboss.jandex"/>
        <module name="org.jboss.logging"/>
        <module name="org.jboss.vfs"/>
        <module name="org.hibernate.commons-annotations"/>
        <module name="org.hibernate.infinispan" services="import" optional="true"/>
        <module name="org.hibernate.jipijapa-hibernate5" services="import"/>
        <module name="org.slf4j"/>
    </dependencies>
</module>
EOL

echo "Installing Hibernate Spatial module resources."
curl -o $HIBERNATE_MODULE/$HIBERNATE_SPATIAL \
       http://central.maven.org/maven2/org/hibernate/hibernate-spatial/$HIBERNATE_VERSION/$HIBERNATE_SPATIAL
curl -o $HIBERNATE_MODULE/$GEOLATTE \
       http://central.maven.org/maven2/org/geolatte/geolatte-geom/$GEOLATTE_VERSION/$GEOLATTE
curl -o $HIBERNATE_MODULE/$JTS \
       http://central.maven.org/maven2/com/vividsolutions/jts-core/$JTS_VERSION/$JTS
curl -o $HIBERNATE_MODULE/$JTS_IO \
       http://central.maven.org/maven2/com/vividsolutions/jts-io/$JTS_IO_VERSION/$JTS_IO
curl -o $HIBERNATE_MODULE/$JSON_SIMPLE \
       http://central.maven.org/maven2/com/googlecode/json-simple/json-simple/$JSON_SIMPLE_VERSION/$JSON_SIMPLE



