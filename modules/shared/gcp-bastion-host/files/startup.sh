#!/bin/bash

set -e
set -o pipefail

SHARED_SOURCES=(
    "gs://proto-legion-global-package-sources/sensible-utils_0.0.17+nmu1_all.deb"
    "gs://proto-legion-global-package-sources/perl_5.36.0-7+deb12u1_amd64.deb"
    "gs://proto-legion-global-package-sources/postgresql-client-common_248_all.deb"
    "gs://proto-legion-global-package-sources/install-info_6.8-6+b1_amd64.deb"
    "gs://proto-legion-global-package-sources/libpq5_15.7-0+deb12u1_amd64.deb"
    "gs://proto-legion-global-package-sources/postgresql-client-15_15.7-0+deb12u1_amd64.deb"
    "gs://proto-legion-global-package-sources/postgresql-client_15+248_all.deb"
    "gs://proto-legion-global-package-sources/google-cloud-ops-agent_2.48.0~debian12_amd64.deb"
)
CLOUDSQL_PROXY="gs://proto-legion-global-package-sources/cloud-sql-proxy.linux.amd64"
INSTANCE_CONNECTION="${instance_connection}"

for SOURCE in $${SHARED_SOURCES[@]}; do
    if [ -z "$SOURCE" ]; then
        continue
    fi

    FILENAME=$(basename "$SOURCE")

    echo ""
    echo "##### Installing $FILENAME"
    echo ""
    gsutil cp "$SOURCE" /tmp/
    dpkg -i "/tmp/$FILENAME" || exit 1
done

gsutil cp $CLOUDSQL_PROXY /opt/cloudsql-proxy
chmod +x /opt/cloudsql-proxy

echo "##### Starting cloudsql-proxy service"

/opt/cloudsql-proxy --port 5432 --private-ip "$INSTANCE_CONNECTION"
