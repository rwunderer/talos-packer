HCLOUD_CONTEXT := $(shell (hcloud context active))

all: build

build:
	HCLOUD_TOKEN="$$TOKEN_$(HCLOUD_CONTEXT)" packer build packer.pkr.hcl

validate:
	HCLOUD_TOKEN="$$TOKEN_$(HCLOUD_CONTEXT)" packer validate packer.pkr.hcl

# vim: noexpandtab
