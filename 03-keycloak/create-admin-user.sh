#!/bin/bash

#
# Creates a Keycloak admin user
# Obviously, the default admin/keycloak credentials should only be used for development installations
#

DIR=`dirname $0`
source $DIR/../02-wildfly/wildfly-env.sh

ADM_USER="admin"
read -e -p "Keycloak admin user [admin]: " USER_INPUT
ADM_USER="${USER_INPUT:-$ADM_USER}"

ADM_PWD="keycloak"
read -e -p "Keycloak admin password [keycloak]: " PWD_INPUT
ADM_PWD="${PWD_INPUT:-$ADM_PWD}"

$WILDFLY_PATH/bin/add-user-keycloak.sh -r master -u "$ADM_USER" -p "$ADM_PWD"
