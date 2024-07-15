#!/bin/bash

# Install GCSFuse and Ops Agent
SOURCES=(
    "gs://proto-legion-global-package-sources/libfuse2_2.9.9-6+b1_amd64.deb"
    "gs://proto-legion-global-package-sources/fuse_2.9.9-6+b1_amd64.deb"
    "gs://proto-legion-global-package-sources/gcsfuse_2.3.1_amd64.deb"
    "gs://proto-legion-global-package-sources/google-cloud-ops-agent_2.48.0~debian12_amd64.deb"
)

for SOURCE in $${SOURCES[@]}; do
    FILENAME=$(basename $SOURCE)

    echo "---- Installing $FILENAME"
    gsutil cp $SOURCE /tmp/
    dpkg -i "/tmp/$FILENAME"
done

echo "---- Done"
