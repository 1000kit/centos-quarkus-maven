FROM quay.io/quarkus/centos-quarkus-maven:19.3.1-java11

USER root

RUN yum -y install fontconfig freetype dejavu-sans-mono-fonts

USER quarkus

