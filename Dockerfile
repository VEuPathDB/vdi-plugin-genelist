FROM amazoncorretto:25-alpine3.22-jdk

ENV LANG=en_US.UTF-8 \
  JVM_MEM_ARGS="-Xms16m -Xmx64m" \
  JVM_ARGS="" \
  TZ="America/New_York" \
  PATH=/opt/veupathdb/bin:$PATH

RUN apk add --no-cache \
     python3 curl wget git tzdata unzip make gcc netcat-openbsd \
     perl perl-dbi perl-test-nowarnings perl-dbd-pg \
  && cp /usr/share/zoneinfo/America/New_York /etc/localtime \
  && echo ${TZ} > /etc/timezone

# DBI UTILS
ARG LIB_DBI_UTILS_VERSION=1.0.0
RUN mkdir -p /opt/veupathdb/lib/perl \
  && cd /opt/veupathdb/lib/perl \
  && wget -q https://github.com/VEuPathDB/lib-perl-dbi-utils/releases/download/v${LIB_DBI_UTILS_VERSION}/dbi-utils-v${LIB_DBI_UTILS_VERSION}.zip -O utils.zip \
  && unzip -qq utils.zip \
  && rm utils.zip

COPY bin/ /opt/veupathdb/bin
COPY lib/ /opt/veupathdb/lib

RUN chmod +x /opt/veupathdb/bin/*

# VDI PLUGIN SERVER
ARG PLUGIN_SERVER_VERSION=v1.7.0-a23
RUN curl "https://github.com/VEuPathDB/vdi-service/releases/download/${PLUGIN_SERVER_VERSION}/plugin-server.tar.gz" -Lf --no-progress-meter | tar -xz

CMD PLUGIN_ID=genelist /startup.sh
