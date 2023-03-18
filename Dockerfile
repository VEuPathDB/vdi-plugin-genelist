FROM veupathdb/vdi-plugin-handler-server:latest

RUN apk add --no-cache bash; \
  mkdir "/opt/veupathdb"

COPY scripts/includes.sh /opt/veupathdb/includes.sh
COPY scripts/import.sh /opt/veupathdb/import
COPY scripts/install-meta.sh /opt/veupathdb/install-meta
COPY scripts/install-data.sh /opt/veupathdb/install-data
COPY scripts/uninstall.sh /opt/veupathdb/uninstall

RUN chmod +x \
  /opt/veupathdb/import \
  /opt/veupathdb/install-meta \
  /opt/veupathdb/install-data \
  /opt/veupathdb/uninstall