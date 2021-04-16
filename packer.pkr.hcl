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

variable "base_image" {
  type    = string
  default = "debian-10"
}

variable "hcloud_token" {
  type    = string
  default = ""
}

variable "image_name" {
  type    = string
  default = "talos"
}

variable "image_version" {
  type    = string
  default = "0.9.1"
}

# could not parse template for following block: "template: hcl2_upgrade:11: function \"formatdate\" not defined"

source "hcloud" "main" {
  image       = var.base_image
  location    = "fsn1"
  rescue      = "linux64"
  server_type = "cx11"
  snapshot_labels = {
    Name    = "${var.image_name}-${var.image_version}"
    Service = "Kubernetes"
  }
  snapshot_name = "${var.image_name}-${var.image_version} ${formatdate("YYYYMMDD", timestamp())}"
  ssh_username  = "root"
  token         = var.hcloud_token
}

build {
  sources = ["source.hcloud.main"]

  provisioner "shell" {
    environment_vars = ["TALOS_VERSION=${var.image_version}"]
    script           = "./tasks/talos.sh"
  }

}

# vim: syntax=tf
