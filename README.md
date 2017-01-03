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

Add a Keycloak admin user using the command

    ./keycloak-folder/bin/add-user-keycloak.sh -r master -u <<user>> -p <<password>>

### Importing a Keycloak Realm

Once Keycloak has been installed, you can start it up with a Niord bootstrap realm. Run the following command:

    ./03-keycloak/import-realm.sh

The imported realm, as defined in niord-bootstrap-realm.json, will create a "Master" Niord domain along with a
system administrator user (sysadmin/sysadmin) that can be used to configure the Niord system.

Use the sysadmin user to create new domains, possibly by importing a Niord base data set, as described in the next section.


## Importing Niord Base Data

Once you have deployed the Niord web application, you can populate the database with a set of base data, including
areas, charts, categories, domains, etc.

Copy the *niord-dev-basedata.zip* archive to the *$NIORD_HOME/batch-jobs/batch-sets/* folder.


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
