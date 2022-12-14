terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = lookup(var.awsprops, "region")
}

resource "aws_security_group" "preconfigured-gitlab-sg" {
  name        = lookup(var.awsprops, "secgroupname")
  description = lookup(var.awsprops, "secgroupname")
  vpc_id      = lookup(var.awsprops, "vpc")

  ## Allow SSH
  ingress {
    from_port   = 22
    protocol    = "6"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ## Allow Port 80 Transport
  ingress {
    from_port   = 80
    protocol    = "6"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "preconfigured-gitlab" {
  ami                         = lookup(var.awsprops, "ami")
  instance_type               = lookup(var.awsprops, "itype")
  subnet_id                   = lookup(var.awsprops, "subnet") #FFXsubnet2
  associate_public_ip_address = lookup(var.awsprops, "publicip")
  key_name                    = lookup(var.awsprops, "keyname")

  vpc_security_group_ids = [
    aws_security_group.preconfigured-gitlab-sg.id
  ]
  root_block_device {
    delete_on_termination = true
    volume_size           = 8
    volume_type           = "gp2"
  }
  tags = {
    Name        = "GITLAB-SERVER01"
    Environment = "DEV"
    OS          = "DEBIAN"
    Managed     = "IAC"
  }
  user_data = file("init.sh")

  depends_on = [aws_security_group.preconfigured-gitlab-sg]
}

# generate inventory file for Ansible
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/templates/ansible-hosts.tpl",
    {
      aws_ec2_ip = aws_instance.preconfigured-gitlab.public_ip
    }
  )
  filename = "../infrastructure-ansible/ansible-hosts.cfg"
}
