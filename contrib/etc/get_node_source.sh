#!/bin/bash

set -ex

NODE_VERSION="${1}"
SRCDIR="${2}"

mkdir -p "${SRCDIR}" || exit 1

# Download and install a binary from nodejs.org
# Add the gpg keys listed at https://github.com/nodejs/node
for key in \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
        B9AE9905FFD7803F25714661B63B535A4C206CA9 \
        77984A986EBC2AA786BC0F66B01FBB92821C587A \
        56730D5401028683275BD23C23EFEFE93C4CFFFE \
        71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
        FD3A5288F042B6850C66B31F09FE44734EB7990E \
        C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
        DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    ; do
    gpg -q --keyserver ipv4.pool.sks-keyservers.net --recv-keys "$key";
    echo "$key:6" | gpg --import-ownertrust
done

# Get the node binary and it's shasum
cd "${SRCDIR}"
curl -O -sSL https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}.tar.gz
curl -O -sSL https://nodejs.org/dist/v${NODE_VERSION}/SHASUMS256.txt.asc
gpg --verify SHASUMS256.txt.asc || exit 1
grep " node-v${NODE_VERSION}.tar.gz" SHASUMS256.txt.asc | sha256sum -c -
