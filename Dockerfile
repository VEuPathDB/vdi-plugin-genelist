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
ARG LIB_DBI_UTILS_VERSION=1.1.1
RUN mkdir -p /opt/veupathdb/lib/perl \
  && cd /opt/veupathdb/lib/perl \
  && wget -q https://github.com/VEuPathDB/lib-perl-dbi-utils/releases/download/v${LIB_DBI_UTILS_VERSION}/dbi-utils-v${LIB_DBI_UTILS_VERSION}.zip -O utils.zip \
  && unzip -qq utils.zip \
  && rm utils.zip

ARG VDI_LIB_PERL_GIT_COMMIT_SHA=9140a27dd476b6caaface44dd4cd797cabcaca93
RUN git clone https://github.com/VEuPathDB/vdi-lib-perl-utils.git \
  && cd vdi-lib-perl-utils \
  && git checkout ${VDI_LIB_PERL_GIT_COMMIT_SHA} \
  && mkdir -p /opt/veupathdb/lib/perl /opt/veupathdb/bin \
  && cp lib/perl/*.pm /opt/veupathdb/lib/perl \
  && rm -rf vdi-lib-perl-utils

RUN perl -MCPAN -e 'install qq(JSON)'

COPY bin/ /opt/veupathdb/bin
COPY lib/ /opt/veupathdb/lib

RUN chmod +x /opt/veupathdb/bin/*

# VDI PLUGIN SERVER
ARG PLUGIN_SERVER_VERSION=v1.9.0
RUN curl "https://github.com/VEuPathDB/vdi-service/releases/download/${PLUGIN_SERVER_VERSION}/plugin-server.tar.gz" -Lf --no-progress-meter | tar -xz

CMD PLUGIN_ID=genelist /startup.sh
