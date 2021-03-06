FROM debian:buster-slim

ENV JAVA_MAJOR 8
ENV JAVA_MINOR 0_227
ENV JAVA_HOME /opt/java

ENV JIRA_HOME /var/atlassian/jira
ENV JIRA_INSTALL /opt/atlassian/jira
ENV JIRA_VERSION 8.13.2


COPY 	jdk1.${JAVA_MAJOR}.${JAVA_MINOR} /opt/jdk1.${JAVA_MAJOR}.${JAVA_MINOR}


RUN  ln -s /opt/jdk1.${JAVA_MAJOR}.${JAVA_MINOR} /opt/java

RUN 	apt update \
	&& apt upgrade -y \
    && apt install curl  ca-certificates -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*  \
    && rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/Europe/Oslo /etc/localtime

RUN	mkdir -p ${JIRA_HOME} \
	&& mkdir -p ${JIRA_INSTALL} \
	&& curl -Ls "https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-${JIRA_VERSION}.tar.gz" | tar -xz --directory "${JIRA_INSTALL}" --strip-components=1 --no-same-owner \
	&& curl -Ls "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.45.tar.gz" | tar -xz --directory "${JIRA_INSTALL}/lib" --strip-components=1 --no-same-owner "mysql-connector-java-5.1.45/mysql-connector-java-5.1.45-bin.jar" \
	&& chown -R daemon:daemon ${JIRA_HOME} \
	&& chown -R daemon:daemon ${JIRA_INSTALL} \
	&& echo -e  "\njira.home=$JIRA_HOME" >> "${JIRA_INSTALL}/atlassian-jira/WEB-INF/classes/jira-application.properties" 

# copy 32 bit setenv
RUN cp "${JIRA_INSTALL}/bin/setenv32.sh" "${JIRA_INSTALL}/bin/setenv.sh"

#increase timeout for starting plugin
RUN sed --in-place  "s/JVM_SUPPORT_RECOMMENDED_ARGS=\"\"/JVM_SUPPORT_RECOMMENDED_ARGS=\"-Datlassian.plugins.enable.wait=300\"/g" "${JIRA_INSTALL}/bin/setenv.sh"
	
RUN echo "jira.index.batch.maxrambuffermb=256\njira.index.interactive.maxrambuffermb=256\n" >>${JIRA_INSTALL}/jira-config.properties

# run as daemon user
USER daemon:daemon

EXPOSE 8080

VOLUME ["/var/atlassian/jira", "/opt/atlassian/jira/logs"]

WORKDIR /var/atlassian/jira

COPY "docker-entrypoint.sh" "/"
ENTRYPOINT ["/docker-entrypoint.sh"]

# Run Atlassian JIRA as a foreground process by default.
COPY "start_jira_delay.sh" "/"
CMD ["/start_jira_delay.sh"]
