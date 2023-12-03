// AWS - Ubuntu Packer Builder
packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.2.7"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  access_key              = ""
  secret_key              = ""
  region                  = "us-east-1"
  ami_name                = "pkr-myapp-v1.0.0-{{timestamp}}"
  source_ami              = "ami-06aa3f7caf3a30282"
  instance_type           = "t2.micro"
  vpc_id                  = "vpc-0a9523d36ba80935c"
  subnet_id               = "subnet-00235fa6acbdeab2d"
  ami_virtualization_type = "hvm"
  ssh_username            = "ubuntu"

  tags = {
    OS_Version    = "Ubuntu Server 20.04 LTS"
    Release       = "Latest"
    Base_AMI_Name = "{{ .SourceAMIName }}"
    Name          = "pkr-myapp-img-v0.1"
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "file" {
    source      = "myapp"
    destination = "/home/ubuntu/myapp"
  }

  provisioner "shell" {
    script = "./app.sh"
  }
}
