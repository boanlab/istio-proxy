git config --global --add safe.directory /work
apt-get update
add-apt-repository ppa:ubuntu-toolchain-r/test -y
apt-get update
apt-get install -y build-essential gawk vim gcc-9 g++-9
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 900
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 900