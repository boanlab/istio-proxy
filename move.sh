#!/bin/bash

cp bazel-out/k8-fastbuild/bin/envoy ./libbssl-backup/
cp -r bazel-out/k8-fastbuild/bin/external/envoy/bssl-compat/bssl-compat/* ./libbssl-backup/
cp bazel-out/k8-fastbuild/bin/external/envoy/bssl-compat/copy_bssl-compat/bssl-compat/ossl.c ./libbssl-backup/