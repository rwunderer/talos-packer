#!/bin/bash
set -exuo pipefail

#   Copyright 2021 capriSys GmbH
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

IMG_EXT="raw.xz"

# expect TALOS_VERSION and TALOS_BASE from environment
URL="https://github.com/talos-systems/talos/releases/download/v${TALOS_VERSION}/${TALOS_BASE}-amd64.${IMG_EXT}"

gdisk -l /dev/sda

curl -fsSL -o talos-amd64.${IMG_EXT} "${URL}"
xz -dc talos-amd64.${IMG_EXT} | dd of=/dev/sda bs=4M

partprobe /dev/sda

sfdisk --delete /dev/sda 5
sfdisk --delete /dev/sda 6

gdisk -l /dev/sda
