FROM veupathdb/vdi-plugin-base:8.1.0-rc8

ARG LIB_DBI_UTILS_VERSION=1.0.0

ENV ORACLE_HOME=/opt/oracle \
  LD_LIBRARY_PATH=/opt/oracle

# PACKAGED DEPENDENCIES
RUN apt-get update \
  && apt-get install -y libaio1t64 libdbi-perl unzip python3 make gcc \
  && apt-get clean \
  && ln -s /usr/lib/x86_64-linux-gnu/libaio.so.1t64 /usr/lib/x86_64-linux-gnu/libaio.so.1

# ORACLE INSTANT CLIENT
RUN mkdir -p ${ORACLE_HOME} \
  && cd ${ORACLE_HOME} \
  && wget -q https://download.oracle.com/otn_software/linux/instantclient/2370000/instantclient-basic-linux.x64-23.7.0.25.01.zip -O instant.zip \
  && wget -q https://download.oracle.com/otn_software/linux/instantclient/2370000/instantclient-sqlplus-linux.x64-23.7.0.25.01.zip -O sqlplus.zip \
  && wget -q https://download.oracle.com/otn_software/linux/instantclient/2370000/instantclient-sdk-linux.x64-23.7.0.25.01.zip -O sdk.zip \
  && wget -q https://download.oracle.com/otn_software/linux/instantclient/2370000/instantclient-tools-linux.x64-23.7.0.25.01.zip -O tools.zip \
  && unzip -o instant.zip \
  && unzip -o sqlplus.zip \
  && unzip -o sdk.zip \
  && unzip -o tools.zip \
  && rm instant.zip sdk.zip sqlplus.zip tools.zip \
  && mv instantclient_23_7/* . \
  && rm -rf instantclient_23_7 \
  && mv -t /usr/bin/ sqlplus sqlldr \
  \
  && cpan ZARQUON/DBD-Oracle-1.83.tar.gz

# DBI UTILS
RUN mkdir -p /opt/veupathdb/lib \
  && cd /opt/veupathdb/lib \
  && wget -q https://github.com/VEuPathDB/lib-perl-dbi-utils/releases/download/v${LIB_DBI_UTILS_VERSION}/dbi-utils-v${LIB_DBI_UTILS_VERSION}.zip -O utils.zip \
  && unzip utils.zip \
  && rm utils.zip

COPY bin/ /opt/veupathdb/bin
COPY lib/ /opt/veupathdb/lib

RUN chmod +x /opt/veupathdb/bin/*
