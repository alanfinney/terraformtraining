#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-d651b8ac
#
# Your subnet ID is:
#
#     subnet-9d9493c7
#
# Your security group ID is:
#
#     sg-2788a154
#
# Your Identity is:
#
#     NWI-vault-rabbit
#

variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
  default = "us-east-1"
}

variable "label" {
  default = "training"
}

variable "count" {
  default = 2
}

module "example" {
  source = "./example-module"
}

terraform {
  backend "atlas" {
    name    = "afinneycredo/training"
    address = "https://atlas.hashicorp.com"
  }
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  count                  = "${var.count}"
  ami                    = "ami-d651b8ac"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-9d9493c7"
  vpc_security_group_ids = ["sg-2788a154"]

  tags {
    "Identity" = "NWI-vault-rabbit"
    "Foo"      = "bar"
    "Zip"      = "zap"
    "Name"     = "${var.label} ${count.index+1}/${var.count}"
    "Bar"      = "Fubar"
  }
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "public_dns" {
  value = "${aws_instance.web.*.public_dns}"
}

output "Name" {
  value = "${aws_instance.web.*.tags.Name}"
}
