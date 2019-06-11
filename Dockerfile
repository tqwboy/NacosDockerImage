FROM debian:stretch-slim
MAINTAINER tqw "jack_coder@outlook.com"

ENV LANG C.UTF-8

# set environment
ENV MODE="cluster" \
    PREFER_HOST_MODE="ip"\
    BASE_DIR="/opt/nacos" \
    CLASSPATH=".:/opt/nacos/conf:$CLASSPATH" \
    CLUSTER_CONF="/opt/nacos/conf/cluster.conf" \
    FUNCTION_MODE="all" \
    NACOS_USER="nacos" \
    TIME_ZONE="Asia/Shanghai"\
    JAVA_HOME="/usr/lib/jvm/java-12-openjdk-amd64"

ARG NACOS_VERSION=1.0.0

RUN apt-get update && apt-get -y upgrade \
    && echo 'deb http://ftp.de.debian.org/debian sid main ' >> '/etc/apt/sources.list' \
    && apt-get -y update \
    && mkdir -p /usr/share/man/man1 \
    && apt-get -y install openjdk-12-jre-headless \
    && apt-get -y install wget \
    && wget https://github.com/alibaba/nacos/releases/download/${NACOS_VERSION}/nacos-server-${NACOS_VERSION}.tar.gz -P /tmp \
    && tar -xzvf /tmp/nacos-server-${NACOS_VERSION}.tar.gz -C /opt \
    && apt-get autoremove -y wget \
    && ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo '$TIME_ZONE' > /etc/timezone \
    && apt-get -y clean \
    && rm -rf /tmp/* /var/tmp/* /var/cache/apt /var/lib/apt/lists/*


WORKDIR /opt/nacos

ADD run.sh /opt/nacos/run.sh

# set startup log dir
RUN mkdir -p logs \
    && cd logs \
    && touch start.out \
    && ln -sf /dev/stdout start.out \
    && ln -sf /dev/stderr start.out \
    && cd /opt/nacos \
    && chmod a+x run.sh

EXPOSE 8848
CMD "/opt/nacos/run.sh"
