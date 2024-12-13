#!/bin/bash

# cp bazel-out/k8-opt/bin/envoy ./libbssl-backup/
# cp -r bazel-out/k8-opt/bin/external/envoy/bssl-compat/bssl-compat/* ./libbssl-backup/
# cp bazel-out/k8-opt/bin/external/envoy/bssl-compat/copy_bssl-compat/bssl-compat/ossl.c ./libbssl-backup/

# cp bazel-out/k8-dbg/bin/envoy ./libbssl-backup/
# cp -r bazel-out/k8-dbg/bin/external/envoy/bssl-compat/bssl-compat/* ./libbssl-backup/
# cp bazel-out/k8-dbg/bin/external/envoy/bssl-compat/copy_bssl-compat/bssl-compat/ossl.c ./libbssl-backup/

# cp /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1 ./libbssl-backup/lib/
cp -r bazel-out/k8-fastbuild/bin/external/envoy/bssl-compat/bssl-compat/* ./libbssl-backup/
cp bazel-out/k8-fastbuild/bin/envoy ./libbssl-backup/
#cp /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1 ./libbssl-backup/lib/
#cp bazel-out/k8-fastbuild/bin/external/envoy/bssl-compat/bssl-compat.build_tmpdir/liboqs/install/lib64/liboqs.so.6 ./libbssl-backup/lib/
# cp bazel-out/k8-fastbuild/bin/external/envoy/bssl-compat/copy_bssl-compat/bssl-compat/ossl.c ./libbssl-backup/