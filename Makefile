all: build

build:
	packer build --var-file=variables.pkrvars.hcl packer.pkr.hcl

validate:
	packer validate --var-file=variables.pkrvars.hcl packer.pkr.hcl

# vim: noexpandtab
