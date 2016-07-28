#!/bin/bash

# Set up the wildfly env 
DIR=`dirname $0`
source $DIR/wildfly-env.sh

# See http://www.nailedtothex.org/roller/kyle/entry/articles-wildfly-javamail
echo "Configure SMTP."
$WILDFLY_PATH/bin/jboss-cli.sh <<EOF
# Start offline server
embed-server --std-out=echo
batch
/socket-binding-group=standard-sockets/remote-destination-outbound-socket-binding=NiordSMTP:add(host=\${env.NIORDSMTP_PORT_23_TCP_ADDR:localhost}, port=\${env.NIORDSMTP_PORT_23_TCP_ADDR:1025})
/subsystem=mail/mail-session=NiordMail:add(jndi-name="java:jboss/mail/Niord", debug=false)
/subsystem=mail/mail-session=NiordMail/server=smtp:add(outbound-socket-binding-ref=NiordSMTP)
run-batch
stop-embedded-server
EOF

