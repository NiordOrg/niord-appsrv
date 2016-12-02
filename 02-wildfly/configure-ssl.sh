#!/bin/bash

# Set up the wildfly env 
DIR=`dirname $0`
source $DIR/wildfly-env.sh

echo "Enabling SSL."
$WILDFLY_PATH/bin/jboss-cli.sh <<EOF
# Start offline server
embed-server --std-out=echo
batch

/subsystem=undertow/server=default-server/http-listener=default:write-attribute(name=proxy-address-forwarding,value=true)
/subsystem=undertow/server=default-server/http-listener=default:write-attribute(name=redirect-socket,value=proxy-https)
/socket-binding-group=standard-sockets/socket-binding=proxy-https:add(port=443)

/subsystem=transactions:write-attribute(name=node-identifier,value=Niord)
/subsystem=undertow/server=default-server/http-listener=default:write-attribute(name=max-post-size,value=1073741824)

run-batch
stop-embedded-server
EOF

