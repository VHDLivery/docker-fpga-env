#!/bin/sh
set -eu
repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
docker build -f "$repo_root/containers/ghdl/Dockerfile" \
  -t "${1:-fpga-env/ghdl:local}" "$repo_root"
