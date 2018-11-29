# sudo docker image build -t tester_java .
# sudo docker container run -d --name tester -p 8080:8080 -p 8000:8000 --link dd-agent:dd-agent tester_java

# build servlet and create war file
FROM maven:latest AS warfile
WORKDIR /usr/src/tester
COPY pom.xml .
RUN mvn -B -f pom.xml -s /usr/share/maven/ref/settings-docker.xml dependency:resolve
COPY . .
RUN mvn -B -s /usr/share/maven/ref/settings-docker.xml package

FROM tomcat:9.0-jre8-alpine
# ADD tomcat/catalina.sh $CATALINA_HOME/bin/
WORKDIR /usr/local/tomcat/bin
COPY run.sh run.sh
RUN chmod +x run.sh
#Copy war file
WORKDIR /usr/local/tomcat/webapps
COPY  --from=warfile /usr/src/tester/target/java-servlet-example-0.0.1-SNAPSHOT.war Tester.war

ENV DD_SERVICE_NAME="java-tester"

LABEL "com.datadoghq.ad.check_names"='["jmx"]'
LABEL "com.datadoghq.ad.init_configs"='[{}]'
LABEL "com.datadoghq.ad.instances"='[{"host": "%%host%%", "port": "7199", "jmx_url": "service:jmx:rmi:///jndi/rmi://%%host%%:7199/jmxrmi"}]'

# Expose ports
EXPOSE 8080
EXPOSE 7199
WORKDIR /usr/local/tomcat/bin
COPY dd-java-agent.jar .
CMD ["run.sh"]
