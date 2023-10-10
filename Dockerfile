FROM veupathdb/vdi-plugin-base:1.0.13

COPY bin/ /opt/veupathdb/bin
COPY lib/ /opt/veupathdb/lib
#COPY testdata/ /opt/veupathdb/testdata

RUN chmod +x /opt/veupathdb/bin/*
