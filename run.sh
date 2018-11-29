#!/bin/sh

export JAVA_OPTS="-javaagent:/usr/local/tomcat/bin/dd-java-agent.jar -Ddd.agent.host=datadog-agent -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=7199 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
exec ${CATALINA_HOME}/bin/catalina.sh jpda run
