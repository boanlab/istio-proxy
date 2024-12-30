#!/bin/bash

# Exit on any error
set -e

# Set environment variables
OPENSSL_VERSION=3.2.0
OPENSSL_ROOTDIR=/usr/local/openssl-3.2.0
export LD_LIBRARY_PATH=/usr/local/openssl-3.2.0/lib64:$LD_LIBRARY_PATH
export PATH=/usr/local/openssl-3.2.0/bin:$PATH
ldconfig

# Install OpenSSL 3.2.0
echo "Installing OpenSSL ${OPENSSL_VERSION}..."
wget -qO- https://github.com/openssl/openssl/releases/download/openssl-3.2.0/openssl-3.2.0.tar.gz | tar xz -C /
cd /openssl-3.2.0
./config -d --prefix=/usr/local/openssl-3.2.0 --openssldir=$OPENSSL_ROOTDIR
make -j$(nproc)
make install_sw install_ssldirs
bash -c "echo /usr/local/openssl-3.2.0/lib64 > /etc/ld.so.conf.d/openssl-3.2.0.conf"
ldconfig

# Add OpenSSL path to system-wide profile
bash -c 'cat >> /etc/profile.d/openssl.sh << EOL
export PATH=/usr/local/openssl-3.2.0/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/openssl-3.2.0/lib64:$LD_LIBRARY_PATH
export OPENSSL_ROOT_DIR=/usr/local/openssl-3.2.0
EOL'

# Make the profile script executable
chmod +x /etc/profile.d/openssl.sh

# Install libOQS
echo "Installing libOQS..."
cd /
wget --no-check-certificate https://github.com/open-quantum-safe/liboqs/archive/refs/tags/0.11.0.tar.gz
tar xzf 0.11.0.tar.gz
rm 0.11.0.tar.gz
cd /liboqs-0.11.0
mkdir build
cd build
cmake \
    -DCMAKE_INSTALL_PREFIX=$OPENSSL_ROOTDIR \
    -DBUILD_SHARED_LIBS=ON \
    -DOQS_USE_OPENSSL=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DOQS_BUILD_ONLY_LIB=ON \
    -DOQS_DIST_BUILD=ON \
    -DCMAKE_INSTALL_LIBDIR=lib64 \
    ..
make -j$(nproc)
make install

# Install oqsprovider
echo "Installing oqsprovider..."
cd /
wget --no-check-certificate https://github.com/open-quantum-safe/oqs-provider/archive/refs/tags/0.7.0.tar.gz
tar xzf 0.7.0.tar.gz
rm 0.7.0.tar.gz
cd /oqs-provider-0.7.0
mkdir build
cd build
cmake -DOPENSSL_ROOT_DIR=$OPENSSL_ROOTDIR \
    -DCMAKE_PREFIX_PATH=$OPENSSL_ROOTDIR \
    -Dliboqs_DIR=$OPENSSL_ROOTDIR/lib64/cmake/liboqs \
    ..
make -j$(nproc)
make install

# Configure OpenSSL
 sed -i "s/default = default_sect/default = default_sect\noqsprovider = oqsprovider_sect/g" $OPENSSL_ROOTDIR/openssl.cnf
 sed -i "s/\[default_sect\]/\[default_sect\]\nactivate = 1\n\[oqsprovider_sect\]\nactivate = 1\n/g" $OPENSSL_ROOTDIR/openssl.cnf

# Set OpenSSL configuration
export OPENSSL_CONF=$OPENSSL_ROOTDIR/openssl.cnf
ldconfig

echo "Installation completed successfully!"
