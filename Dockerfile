FROM quay.io/quarkus/centos-quarkus-maven:19.3.1-java11 as samo

ENV SAMO_VER 1.13.0
RUN curl https://github.com/lorislab/samo/releases/download/$SAMO_VER/samo_${SAMO_VER}_Linux_x86_64.tar.gz -O -J -L && \
    tar xfz samo_${SAMO_VER}_Linux_x86_64.tar.gz samo && \
    chmod +x samo

FROM quay.io/quarkus/centos-quarkus-maven:19.3.1-java11

USER root

RUN yum install -y yum-utils device-mapper-persistent-data lvm2 \
    && yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

RUN yum -y install fontconfig freetype dejavu-sans-mono-fonts docker-ce

COPY --from=samo /project/samo /usr/local/bin/samo

USER quarkus

