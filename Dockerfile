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

FROM alpine:3.12 as builder

RUN apk --no-cache add \
  curl

WORKDIR /usr/local/share

RUN curl -sSL https://download.sonatype.com/nexus/3/latest-unix.tar.gz > ./nexus.tar.gz
RUN echo "$(curl -sSL https://download.sonatype.com/nexus/3/latest-unix.tar.gz.md5)  ./nexus.tar.gz" > ./nexus.tar.gz.md5
RUN md5sum -c ./nexus.tar.gz.md5
RUN tar -xf ./nexus.tar.gz && rm ./nexus.tar.gz ./nexus.tar.gz.md5 && mv ./nexus* ./nexus
RUN curl -sSLI https://download.sonatype.com/nexus/3/latest-unix.tar.gz.md5 | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+\-[0-9]\+' > ./nexus/VERSION

FROM alpine:3.12

LABEL maintainer="Decipher Engineering <build@greymatter.io>"

RUN apk --no-cache add \
  curl \
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
