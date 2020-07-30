provider "linode" {
    token = var.token
}

locals {
  create_time = "${formatdate("hh_mm_ss", timestamp())}"
}

resource "linode_instance" "ha_instances" {
  count = var.node_count
  image = "linode/ubuntu18.04"
  label = "${var.label}_instance_${local.create_time}_${count.index}"
  region = "us-central"
  type = "g6-standard-4" # https://cloud.linode.com/api/v4/linode/types
  authorized_keys = [var.ssh_key]
  root_pass = var.root_pass

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      timeout  = "2m"
      host     = self.ip_address
      user     = "root"
      agent    = "true"
      password = var.root_pass
      # private_key = var.ssh_key
    }
    inline = [
      "export PATH=$PATH:/usr/bin",
      "apt-get update -y",
      "apt-get remove docker docker-engine docker.io -y",
      "apt install docker.io -y",
      "systemctl start docker",
      "systemctl enable docker",
      "docker --version",
    ]
  }
}

variable token {}
variable root_pass {}
variable ssh_key {}
variable node_count {}
variable label {}
