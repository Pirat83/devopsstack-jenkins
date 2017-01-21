FROM jenkins:latest
MAINTAINER Rafael Kansy <rafael.kansy@blue-sharp.de>

# Install Docker.
USER root
RUN apt-get update && apt-get install -y apt-utils apt-transport-https ca-certificates && rm -rf /var/lib/apt/lists/*
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo 'deb https://apt.dockerproject.org/repo debian-jessie main' >> /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-engine && rm -rf /var/lib/apt/lists/*
#RUN systemctl start docker

USER jenkins
# Jenkins settings
COPY config/* /usr/share/jenkins/ref/
COPY config/.m2/settings.xml /usr/share/jenkins/ref/.m2/settings.xml
# Adding default Jenkins Jobs
COPY jobs/Blue-Sharp.xml /usr/share/jenkins/ref/jobs/Blue-Sharp/config.xml
# Add Docker client certificate for authentication
COPY ssl/* /usr/share/jenkins/ref/.docker/
# Add plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh $(cat /usr/share/jenkins/ref/plugins.txt | tr '\n' ' ')

ENV JENKINS_OPTS --prefix=/jenkins