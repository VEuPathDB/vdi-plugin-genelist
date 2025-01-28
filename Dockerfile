FROM veupathdb/vdi-plugin-base:8.1.0-rc1

COPY bin/ /opt/veupathdb/bin
COPY lib/ /opt/veupathdb/lib

RUN chmod +x /opt/veupathdb/bin/*
