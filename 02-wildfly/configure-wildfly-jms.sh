#!/bin/bash

# Set up the wildfly env
DIR=`dirname $0`
source $DIR/wildfly-env.sh

# Mainly based on http://stackoverflow.com/questions/24921640/how-to-set-up-messaging-subsystem-using-cli-in-wildfly
# NB: As an alternative, we could just have used the standalone-full profile

echo "Configuring JMS sub-system"
$WILDFLY_PATH/bin/jboss-cli.sh <<EOF
# Start offline server
embed-server --std-out=echo

/extension=org.wildfly.extension.messaging-activemq:add()

batch
/subsystem=messaging-activemq:add
/subsystem=messaging-activemq/server=default:add
/subsystem=messaging-activemq/server=default/security-setting=#:add
/subsystem=messaging-activemq/server=default/security-setting=#/role=guest:add(consume=true,delete-non-durable-queue=true,create-non-durable-queue=true,send=true)
/subsystem=messaging-activemq/server=default/address-setting=#:add(dead-letter-address="jms.queue.DLQ", expiry-address="jms.queue.ExpiryQueue", max-size-bytes=10485760, page-size-bytes=2097152, message-counter-history-day-limit=10)
/subsystem=messaging-activemq/server=default/http-connector=http-connector:add(socket-binding="http", endpoint="http-acceptor")
/subsystem=messaging-activemq/server=default/http-connector=http-connector-throughput:add(socket-binding="http", endpoint="http-acceptor-throughput" ,params={batch-delay="50"})
/subsystem=messaging-activemq/server=default/in-vm-connector=in-vm:add(server-id="0")
/subsystem=messaging-activemq/server=default/http-acceptor=http-acceptor:add(http-listener="default")
/subsystem=messaging-activemq/server=default/http-acceptor=http-acceptor-throughput:add(http-listener="default", params={batch-delay="50", direct-deliver="false"})
/subsystem=messaging-activemq/server=default/in-vm-acceptor=in-vm:add(server-id="0")
/subsystem=messaging-activemq/server=default/jms-queue=ExpiryQueue:add(entries=["java:/jms/queue/ExpiryQueue"])
/subsystem=messaging-activemq/server=default/jms-queue=DLQ:add(entries=["java:/jms/queue/DLQ"])
run-batch

batch
/subsystem=messaging-activemq/server=default/connection-factory=InVmConnectionFactory:add(connectors=["in-vm"], entries=["java:/ConnectionFactory"])
/subsystem=messaging-activemq/server=default/connection-factory=RemoteConnectionFactory:add(connectors=["http-connector"], entries = ["java:jboss/exported/jms/RemoteConnectionFactory"])
/subsystem=messaging-activemq/server=default/pooled-connection-factory=activemq-ra:add(transaction="xa", connectors=["in-vm"], entries=["java:/JmsXA java:jboss/DefaultJMSConnectionFactory"])
/subsystem=ee/service=default-bindings/:write-attribute(name="jms-connection-factory", value="java:jboss/DefaultJMSConnectionFactory")
/subsystem=ejb3:write-attribute(name="default-resource-adapter-name", value="\${ejb.resource-adapter-name:activemq-ra.rar}")
/subsystem=ejb3:write-attribute(name="default-mdb-instance-pool", value="mdb-strict-max-pool")
run-batch

/subsystem=messaging-activemq/server=default/jms-topic=MessageStatusTopic:add(entries=[java:/jms/topic/MessageStatusTopic])

stop-embedded-server
EOF
