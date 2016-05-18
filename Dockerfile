FROM jenkins:latest
MAINTAINER Rafael Kansy <rafael.kansy@blue-sharp.de>

USER jenkins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt

# Adding default Jenkins Jobs
# COPY jobs/GitHub-seed-job.xml /usr/share/jenkins/ref/jobs/GitHub-seed-job/config.xml

# Jenkins settings
COPY config/* /usr/share/jenkins/ref/
COPY config/.m2/settings.xml /usr/share/jenkins/ref/.m2/settings.xml

# Add Docker client certificate for authentication
USER jenkins
COPY ssl/* /usr/share/jenkins/ref/.docker/

# Install Docker.
USER root
RUN apt-get update && apt-get install -y apt-utils apt-transport-https ca-certificates && rm -rf /var/lib/apt/lists/*
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo 'deb https://apt.dockerproject.org/repo debian-jessie main' >> /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-engine && rm -rf /var/lib/apt/lists/*
RUN service docker start

USER jenkins