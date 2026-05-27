#!/bin/sh
ARCH="x86_64_linux"

if [ "$1" != "free" -a "$1" != "unfree" -a "$1" != "all" ]; then
    echo "Usage: $0 [free|unfree|all]"
    exit 1
fi
set -e
rm -rf "dest"
mkdir -p "dest"
touch "dest/nixos_${ARCH}.xml"

combine() {
    cp -r "$1/icons" "dest/"
}

echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<components version=\"0.14\" origin=\"nixos\">" > "dest/nixos_${ARCH}.xml"

if [ "$1" = "all" ]; then
	combine "nixos-unstable"
	combine "nixos-unstable-unfree"
else
    combine "$1"
fi

echo "</components>" >> "dest/nixos_${ARCH}.xml"

appstreamcli convert "dest/nixos_${ARCH}.xml" "dest/nixos_${ARCH}.yml"
gzip "dest/nixos_${ARCH}.xml"
gzip "dest/nixos_${ARCH}.yml"
