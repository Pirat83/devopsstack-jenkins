FROM jenkins/jenkins:lts
MAINTAINER Rafael Kansy <rafael.kansy@blue-sharp.de>

# Install Docker.
USER root
RUN apt-get update && apt-get install -y apt-utils apt-transport-https ca-certificates && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y docker-ce && rm -rf /var/lib/apt/lists/*

USER jenkins
# Jenkins settings
COPY config/* /usr/share/jenkins/ref/
# Adding default Jenkins Jobs
COPY jobs/Blue-Sharp.xml /usr/share/jenkins/ref/jobs/Blue-Sharp/config.xml
# Add plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
#ENV JENKINS_OPTS --prefix=/jenkins