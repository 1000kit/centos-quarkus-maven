FROM quay.io/quarkus/centos-quarkus-maven:19.3.1-java11

USER root

RUN yum install -y yum-utils device-mapper-persistent-data lvm2 \
    && yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo


RUN yum -y install fontconfig freetype dejavu-sans-mono-fonts docker-ce

USER quarkus

