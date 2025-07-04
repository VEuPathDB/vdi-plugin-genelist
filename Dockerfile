FROM foxcapades/ubuntu-corretto:24.10-jdk21

ENV LANG=en_US.UTF-8 \
  JVM_MEM_ARGS="-Xms16m -Xmx64m" \
  JVM_ARGS="" \
  TZ="America/New_York" \
  PATH=/opt/veupathdb/bin:$PATH

RUN apt-get update \
  && apt-get install -y locales python3 curl wget git \
  && sed -i -e "s/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen \
  && dpkg-reconfigure --frontend=noninteractive locales \
  && update-locale LANG=en_US.UTF-8 \
  && apt-get install -y tzdata perl libaio1t64 libdbi-perl unzip libtest-nowarnings-perl make gcc \
  && cp /usr/share/zoneinfo/America/New_York /etc/localtime \
  && echo ${TZ} > /etc/timezone \
  && apt-get clean \
  && ln -s /usr/lib/x86_64-linux-gnu/libaio.so.1t64 /usr/lib/x86_64-linux-gnu/libaio.so.1

# ORACLE INSTANT CLIENT
ENV ORACLE_HOME=/opt/oracle \
  LD_LIBRARY_PATH=/opt/oracle
RUN mkdir -p ${ORACLE_HOME} \
  && cd ${ORACLE_HOME} \
  && wget -q https://download.oracle.com/otn_software/linux/instantclient/2370000/instantclient-basic-linux.x64-23.7.0.25.01.zip -O instant.zip \
  && wget -q https://download.oracle.com/otn_software/linux/instantclient/2370000/instantclient-sqlplus-linux.x64-23.7.0.25.01.zip -O sqlplus.zip \
  && wget -q https://download.oracle.com/otn_software/linux/instantclient/2370000/instantclient-sdk-linux.x64-23.7.0.25.01.zip -O sdk.zip \
  && wget -q https://download.oracle.com/otn_software/linux/instantclient/2370000/instantclient-tools-linux.x64-23.7.0.25.01.zip -O tools.zip \
  && unzip -qqo instant.zip \
  && unzip -qqo sqlplus.zip \
  && unzip -qqo sdk.zip \
  && unzip -qqo tools.zip \
  && rm instant.zip sdk.zip sqlplus.zip tools.zip \
  && mv instantclient_23_7/* . \
  && rm -rf instantclient_23_7 \
  && mv -t /usr/bin/ sqlplus sqlldr \
  \
  && cpan ZARQUON/DBD-Oracle-1.83.tar.gz

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
ARG PLUGIN_SERVER_VERSION=v1.7.0-b.6
RUN curl "https://github.com/VEuPathDB/vdi-service/releases/download/${PLUGIN_SERVER_VERSION}/plugin-server.tar.gz" -Lf --no-progress-meter | tar -xz

CMD PLUGIN_ID=genelist /startup.sh
