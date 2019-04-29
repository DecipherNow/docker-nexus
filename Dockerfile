# Copyright 2019 Decipher Technology Studios
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM alpine:3.8 as builder

ARG NEXUS_VERSION=3.15.2-01
ARG HELM_REPOSITORY_VERSION=0.0.8
ARG HELM_REPOSITORY_COMMIT=a00b0cf9706992999bb5344bac51d0795dabb266

RUN apk --no-cache add \
  curl \
  git \
  maven \
  openjdk8-jre

WORKDIR /usr/local/share

RUN curl -sSL https://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz | tar -xz
RUN mv nexus-${NEXUS_VERSION} nexus

WORKDIR /usr/local/src

RUN git clone https://github.com/worldremit/nexus-repository-helm.git

WORKDIR /usr/local/src/nexus-repository-helm

RUN git reset --hard ${HELM_REPOSITORY_COMMIT}
RUN mvn clean package
RUN mkdir -p /usr/local/share/nexus/system/org/sonatype/nexus/plugins/nexus-repository-helm/${HELM_REPOSITORY_VERSION}
RUN cp ./target/nexus-repository-helm-${HELM_REPOSITORY_VERSION}.jar /usr/local/share/nexus/system/org/sonatype/nexus/plugins/nexus-repository-helm/${HELM_REPOSITORY_VERSION}/nexus-repository-helm-${HELM_REPOSITORY_VERSION}.jar

WORKDIR /

COPY versions/${NEXUS_VERSION}/patch.diff ./patch.diff

RUN patch -p1 /usr/local/share/nexus/system/org/sonatype/nexus/assemblies/nexus-core-feature/${NEXUS_VERSION}/nexus-core-feature-${NEXUS_VERSION}-features.xml patch.diff

FROM alpine:3.8

LABEL maintainer="Joshua Rutherford <joshua.rutherfor@deciphernow.com>"

RUN apk --no-cache add \
  openjdk8-jre

WORKDIR /usr/local/share/nexus

COPY --from=builder /usr/local/share/nexus .
COPY files/ /

RUN ln -s /usr/local/share/nexus/bin/nexus /usr/local/bin/nexus
RUN mkdir -p /var/lib/nexus/sonatype-work
RUN chgrp -R 0 /var/lib/nexus
RUN chmod -R g=u /var/lib/nexus

RUN chmod g=u /etc/passwd

EXPOSE 8081
USER   1000
VOLUME /var/lib/nexus/sonatype-work

ENTRYPOINT ["/usr/local/bin/entrypoint"]

CMD ["nexus", "run"]