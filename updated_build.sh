#!/bin/sh
ARCH="x86_64_linux"

if [ "$1" != "free" ] && [ "$1" != "unfree" ] && [ "$1" != "all" ]; then
    echo "Usage: $0 [free|unfree|all]"
    exit 1
fi

set -e
rm -rf "dest"
mkdir -p "dest/icons"

echo '<?xml version="1.0" encoding="utf-8"?>' > "dest/nixos_${ARCH}.xml"
echo '<components version="0.14" origin="nixos">' >> "dest/nixos_${ARCH}.xml"

combine_components() {
    local source_dir="$1"
    if [ -f "./${source_dir}/Components-x86_64-linux.xml" ]; then
        sed '1,2d; $d' "./${source_dir}/Components-x86_64-linux.xml" >> "dest/nixos_${ARCH}.xml"
    fi
    
    if [ -d "./${source_dir}/icons" ]; then
        cp -r "./${source_dir}/icons/." "dest/icons/"
    fi
}

if [ "$1" = "all" ] || [ "$1" = "free" ]; then
    combine_components "nixos-unstable"
fi

if [ "$1" = "all" ] || [ "$1" = "unfree" ]; then
    combine_components "nixos-unstable-unfree"
fi

echo "</components>" >> "dest/nixos_${ARCH}.xml"

appstreamcli convert "dest/nixos_${ARCH}.xml" "dest/nixos_${ARCH}.yml"
gzip -9 "dest/nixos_${ARCH}.xml"
gzip -9 "dest/nixos_${ARCH}.yml"

echo "Successfully built AppStream metadata for: $1"
