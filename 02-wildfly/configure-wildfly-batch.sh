#!/bin/bash

# Set up the wildfly env
DIR=`dirname $0`
source $DIR/wildfly-env.sh

DS_NAME=niordDS

$WILDFLY_PATH/bin/jboss-cli.sh <<EOF
# Start offline server
embed-server --std-out=echo

/subsystem=batch-jberet/jdbc-job-repository=jdbc:add(data-source=$DS_NAME)
/subsystem=batch-jberet/:write-attribute(name=default-job-repository,value=jdbc)

stop-embedded-server
EOF


#        <subsystem xmlns="urn:jboss:domain:batch-jberet:1.0">
#            <default-job-repository name="in-memory"/>
#            <default-thread-pool name="batch"/>
#            <job-repository name="in-memory">
#                <in-memory/>
#           </job-repository>
#            <thread-pool name="batch">
#               <max-threads count="10"/>
#               <keepalive-time time="30" unit="seconds"/>
#           </thread-pool>
#        </subsystem>
