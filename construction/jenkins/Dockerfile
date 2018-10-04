# FROM jenkins/jenkins:lts
FROM jenkins/jenkins:$VERSION_IMAGE_JENKINS

MAINTAINER Jean-Baptiste Lasselle @ Kytes

USER root

RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

RUN apt-get update \
      && apt-get install -y sudo \
      && apt-get install -y vim \
      && rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

USER jenkins

# COPY plugins.txt /usr/share/jenkins/plugins.txt
# RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
ENV JAVA_OPTS="-Xmx8192m"
ENV JENKINS_OPTS="--handlerCountStartup=100 --handlerCountMax=300 --prefix=/var/jenkins_home"


RUN /usr/local/bin/install-plugins.sh git:2.6.0
RUN /usr/local/bin/install-plugins.sh  docker-workflow:1.17
