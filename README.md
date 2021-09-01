[![GitHub license](https://img.shields.io/github/license/rwunderer/talos-packer.svg)](https://github.com/rwunderer/talos-packer/blob/main/LICENSE)

# Packer template to build Talos image on Hetzner Cloud

Builds snapshot on [Hetzner Cloud](https://cloud.hetzner.de) that can be used
as a base image to run a [Talos](https://talos.dev) based Kubernetes cluster.

## Usage

### Prerequisites

* [packer](https://packer.io)
* GNU make (optional)

### Usage

Set the environment variable `HCLOUD_TOKEN` to the [API token](https://docs.hetzner.cloud/#authentication) for authenticating to the Hetzner API.

Run

```
make validate && make build
```

to validate the configuration and run the build. The resulting snapshot will be named `talos-x.y.z YYYYMMDD`.
You can use this snapshot as base image for launching a server to build a Talos cluster.

## How it works

Talos does not natively support Hetzner, however we can use the image for openstack
to build upon. (The _metal_ variant should work as well, but with _openstack_ it's
possible to configure a newly created instance by means of `user_data`).

We launch the smallest possible Hetzner server (CX11). The server is booted directly
into resuce mode, so it does not matter which base image we specify.

Once in resuce mode all that needs to be done is download the latest openstack image
from https://github.com/talos-systems/talos/releases, unpack the archive and write
the included .raw file to the disk.

This overwrites the base image we specified when starting the server. We then delete
partitions 5 (STATE) and 6 (EPHEMERAL) as this will enable us to [encrypt](https://www.talos.dev/docs/v0.10/guides/disk-encryption/)
these when building our actual servers.

All this happens in `tasks/talos.sh`.

The resulting server is then snapshotted by packer.
