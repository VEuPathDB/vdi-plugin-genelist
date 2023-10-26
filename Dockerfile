FROM veupathdb/vdi-plugin-handler-server:2.0.0

RUN apt-get update \
    && apt-get install -y python3 \
    && apt-get clean \
    && ln -s /usr/bin/python3 /usr/bin/python

COPY bin/ /opt/veupathdb/bin
COPY lib/ /opt/veupathdb/lib
#COPY testdata/ /opt/veupathdb/testdata

RUN chmod +x /opt/veupathdb/bin/*
