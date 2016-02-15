# niord-appsrv

The Niord web application runs in a JBoss Wildfly server and require MySQL and JBoss Keycloak to function.

The scripts of this project folder will install and configure a development server system running at localhost, 
and Keycloak will be deployed as an overlay to the Wildfly server.

## Prerequisites

* Java 8
* Maven 3
* MySQL 5.7.10+ (NB: proper spatial support is a requirement)


### Windows

Currently, the installation scripts are for Bash, i.e. unix-platforms. Feel free to contribute Windows scripts ;-)


## MySQL Configuration

Two databases are needed, one for Keycloak and one for the Niord web application.

    mysql -u root -p < 01-mysql/create-keycloak-db.sql
    mysql -u root -p < 01-mysql/create-niord-db.sql


## Wildfly Installation and Configuration

    ./02-wildfly/install-wildfly.sh


## Keycloak Installation and Configuration

The default development set-up will install Keycloak as a overlay to the Wildfly server running the Niord application.

    ./03-keycloak/install-keycloak-overlay.sh


### Importing a Keycloak Realm

You may want to start out with a pre-configured Keycloak realm for development purposes. Run the following command:

    ./03-keycloak/import-realm.sh



