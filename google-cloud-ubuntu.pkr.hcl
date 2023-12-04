// Google Cloud - Ubuntu Packer Builder
packer {
  required_plugins {
    googlecompute = {
      version = ">= 3.1.0"
      source  = "hashicorp/googlecompute"
    }
  }
}

source "googlecompute" "ubuntu" {
  project_id      = ""
  source_image    = "ubuntu-2004-focal-v20231110"
  zone            = "us-central1-a"
  machine_type    = "n1-standard-1"
  disk_size       = "10"
  disk_type       = "pd-standard"
  image_family    = "ubuntu-2004-lts"
  image_project   = "ubuntu-os-cloud"
}

build {
  sources = ["source.googlecompute.ubuntu"]

  provisioner "file" {
    source      = "myapp"
    destination = "/home/ubuntu/myapp"
  }

  provisioner "shell" {
    script = "./app.sh"
  }
}

