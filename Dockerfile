FROM veupathdb/vdi-plugin-handler-server:2.0.0

COPY bin/ /opt/veupathdb/bin
COPY lib/ /opt/veupathdb/lib
#COPY testdata/ /opt/veupathdb/testdata

RUN chmod +x /opt/veupathdb/bin/*
