#!/bin/bash

set -e
set -u
set -x

URL="http://archive.ubuntu.com/ubuntu/pool/main/g/graphviz/graphviz_2.36.0-0ubuntu3.1_amd64.deb"
d=$(mktemp -dt XXXX)
curl -s "$URL" -o "$d"/pkg.deb

# Unpack and install binaries
dpkg -x "$d"/pkg.deb "$d"
mkdir -p /tmp/graphviz/bin
mv "$d"/usr/bin/* /tmp/graphviz/bin

exec ruby run.rb
