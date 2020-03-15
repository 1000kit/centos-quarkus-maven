FROM quay.io/quarkus/centos-quarkus-maven:19.3.1-java11 as oc

ENV OC_VERSION=v3.11.0 \
    OC_TAG_SHA=0cbc58b

RUN curl -sLo /tmp/oc.tar.gz https://github.com/openshift/origin/releases/download/${OC_VERSION}/openshift-origin-client-tools-${OC_VERSION}-${OC_TAG_SHA}-linux-64bit.tar.gz \
    && tar xzvf /tmp/oc.tar.gz -C /tmp/ \
    && mv /tmp/openshift-origin-client-tools-${OC_VERSION}-${OC_TAG_SHA}-linux-64bit/oc /tmp/ \
    && rm -rf /tmp/oc.tar.gz /tmp/openshift-origin-client-tools-${OC_VERSION}-${OC_TAG_SHA}-linux-64bit \
    && ls -all .

FROM quay.io/quarkus/centos-quarkus-maven:19.3.1-java11 as helm

ENV HELM_VERSION=v3.1.2

RUN curl "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" -o "helm.tar.gz" \
    && tar xzvf helm.tar.gz \
    && curl "https://get.helm.sh/helm-v3.0.0-beta.4-linux-amd64.zip" -o "helm3beta4.zip" \
    && unzip helm3beta4.zip -d /tmp/ \
    && ls -all .

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
COPY --from=oc /tmp/oc /usr/local/bin/
COPY --from=helm linux-amd64 /usr/local/bin
COPY --from=helm /tmp/linux-amd64/helm /usr/local/bin/helm3beta4

USER quarkus

