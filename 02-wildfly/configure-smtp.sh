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
/socket-binding-group=standard-sockets/remote-destination-outbound-socket-binding=NiordSMTP:add(host=\${env.NIORDSMTP_PORT_25_TCP_ADDR:localhost}, port=\${env.NIORDSMTP_PORT_25_TCP_PORT:1025})
/subsystem=mail/mail-session=NiordMail:add(jndi-name="java:jboss/mail/Niord", debug=false)
/subsystem=mail/mail-session=NiordMail/server=smtp:add(outbound-socket-binding-ref=NiordSMTP)

/subsystem=ee/managed-executor-service=MailExecutorService:add(jndi-name=java\:jboss\/ee\/concurrency\/executor\/MailExecutorService, core-threads=2, max-threads=2)

run-batch
stop-embedded-server
EOF

