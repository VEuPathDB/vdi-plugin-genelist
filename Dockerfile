FROM veupathdb/vdi-plugin-base:5.2.1

COPY bin/ /opt/veupathdb/bin
COPY lib/ /opt/veupathdb/lib

RUN chmod +x /opt/veupathdb/bin/*
