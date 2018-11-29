# installing java

https://www.liquidweb.com/kb/how-to-install-oracle-java-8-in-ubuntu-16-04/

sudo apt-get update
sudo apt-get upgrade
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer

# get info
java -version
update-alternatives --config java

```
Selection    Path                                     Priority   Status
------------------------------------------------------------
0            /usr/lib/jvm/java-8-oracle/jre/bin/java   1081      auto mode
* 1            /usr/lib/jvm/java-8-oracle/jre/bin/java   1081      manual mode
```

sudo vim /etc/environment/

```
JAVA_HOME="/usr/lib/jvm/java-8-oracle/jre/bin/java"
```

source /etc/environment
echo $JAVA_HOME

# install maven

sudo apt-get -y install maven

# install tomcat

//sudo groupadd tomcat
//sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
sudo mkdir /opt/tomcat
cd /opt/tomcat
sudo wget https://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.35/bin/apache-tomcat-8.5.35.tar.gz
sudo tar xvzf apache-tomcat-8.5.35.tar.gz

### Set Java and Tomcat environments

Note: exclude "/bin/java" from JAVA_HOME paths.

sudo vim /etc/environment/

```
JAVA_HOME="/usr/lib/jvm/java-8-oracle/jre"
CATALINA_HOME="/opt/tomcat/apache-tomcat-8.5.35"
```

or

sudo vim ~/.bashrc

```
export JAVA_HOME="/usr/lib/jvm/java-8-oracle/jre"
export CATALINA_HOME="/opt/tomcat/apache-tomcat-8.5.35"
```

### Set options for JMX

sudo vim /opt/tomcat/apache-tomcat-8.5.35/bin/setenv.sh

```
CATALINA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=7199 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
```

### Test and run

sudo $CATALINA_HOME/bin/startup.sh
curl http://127.0.0.1:8080

Datadog agent will connect to the following jmx port by default:

service:jmx:rmi:///jndi/rmi://localhost:7199/jmxrmi

, "jmx_url": "service:jmx:rmi:///jndi/rmi://%%host%%:%%port%%/jmxrmi"

## Trace agent

cd /opt/tomcat/apache-tomcat-8.5.35/bin
wget -O dd-java-agent.jar 'https://search.maven.org/classic/remote_content?g=com.datadoghq&a=dd-java-agent&v=LATEST'

sudo vim setenv.sh

```
CATALINA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=7199 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -javaagent:/opt/tomcat/apache-tomcat-8.5.35/bin/dd-java-agent.jar"
```

## Setfacl for dd-agent on logs

setfacl -m u:dd-agent:rx /opt/tomcat/apache-tomcat-8.5.35/logs/catalina.out

## datadog-agent jmx + logs config

init_config:

instances:
  - host: localhost
    port: 7199

logs:

  - type: file
    path: /opt/tomcat/apache-tomcat-8.5.35/logs/catalina.out
    service: java-app
    source: tomcat
