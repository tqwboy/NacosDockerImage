FROM tqwboy/java12:1.0.0
MAINTAINER tqw "jack_coder@outlook.com"

ENV LANG C.UTF-8

# set environment
ENV MODE="standalone" \
    PREFER_HOST_MODE="ip"\
    BASE_DIR="/home/nacos" \
    CLASSPATH=".:/home/nacos/conf:$CLASSPATH" \
    CLUSTER_CONF="/home/nacos/conf/cluster.conf" \
    NACOS_USER="nacos" \
    JAVA="/usr/lib/jvm/java-12-openjdk-amd64/bin/java" \
    JVM_XMS="2g" \
    JVM_XMX="2g" \
    JVM_XMN="1g" \
    JVM_MS="128m" \
    JVM_MMS="320m" \
    NACOS_DEBUG="n" \
    TOMCAT_ACCESSLOG_ENABLED="false"

ARG NACOS_VERSION=1.1.3

WORKDIR /$BASE_DIR

ADD nacos-server-1.1.3.tar.gz /home/

RUN set -x \
    && rm -rf /home/nacos/bin/* /home/nacos/conf/*.properties /home/nacos/conf/*.example /home/nacos/conf/nacos-mysql.sql \
    && ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo '$TIME_ZONE' > /etc/timezone

ADD docker-startup.sh bin/docker-startup.sh
ADD application.properties conf/application.properties

# set startup log dir
RUN mkdir -p logs \
    && cd logs \
    && touch start.out \
    && ln -sf /dev/stdout start.out \
    && ln -sf /dev/stderr start.out \
    && cd /home/nacos/bin \
    && chmod a+x docker-startup.sh

EXPOSE 8848
ENTRYPOINT ["bin/docker-startup.sh"]