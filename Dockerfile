FROM veupathdb/vdi-plugin-base:3.2.0

COPY bin/ /opt/veupathdb/bin
COPY lib/ /opt/veupathdb/lib

RUN chmod +x /opt/veupathdb/bin/*
