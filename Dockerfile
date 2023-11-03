FROM veupathdb/vdi-plugin-base:2.0.3

COPY bin/ /opt/veupathdb/bin
COPY lib/ /opt/veupathdb/lib

RUN chmod +x /opt/veupathdb/bin/*
