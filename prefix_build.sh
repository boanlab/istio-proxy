#!/bin/bash

set -e

WORK_DIR=$(pwd)
rm -rf /envoy-openssl/bssl-compat/prefixer/build
mkdir /envoy-openssl/bssl-compat/prefixer/build/
cd /envoy-openssl/bssl-compat/prefixer/build/
echo "Building prefixer..."
cmake ..
make
echo "Moving prefixer to parent directory..."
mv prefixer ..
cd "$WORK_DIR"
echo "Build process completed successfully!"
