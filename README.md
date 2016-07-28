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

Installs a Wildfly server and configures a MySQL data source, a Hibernate Spatial module and a Keycloak adapter.

    ./02-wildfly/install-wildfly.sh


## Keycloak Installation and Configuration

The default development set-up will install Keycloak as a overlay to the Wildfly server running the Niord application.

    ./03-keycloak/install-keycloak-overlay.sh


### Importing a Keycloak Realm

You may want to start out with a pre-configured Keycloak realm for development purposes. Run the following command:

    ./03-keycloak/import-realm.sh


### Running behind a reverse SSL proxy

If you run Niord behind an Apache Web Server, say via docker on port 8081, add a VirtualHost along the lines of:

    <VirtualHost *:443>
        ServerName niord.e-navigation.net
        SSLEngine On
        SSLCertificateFile /path/to/ssl-cert.crt
        SSLCertificateKeyFile /path/to/ssl-cert.key
        SSLCACertificateFile /path/to/ssl-cert.crt
        ProxyPass           /robots.txt !
        ProxyPass           /  http://localhost:8081/
        ProxyPassReverse    /  http://localhost:8081/
        ProxyRequests Off
        ProxyPreserveHost On
        RequestHeader set originalScheme "https"
        RequestHeader set X-Forwarded-Proto "https"
        RequestHeader set X-Forwarded-Port "443"
    </VirtualHost>
