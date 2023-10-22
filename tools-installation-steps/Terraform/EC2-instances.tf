terraform {
required_providers {
aws = {
source = "hashicorp/aws"
version = "~> 4.16"
}
}
required_version = ">= 1.2.0"
}

provider "aws" {
region = "ap-south-1"
}

resource "aws_instance" "webserver" {
ami = "ami-0f5ee92e2d63afc18"
instance_type = "t2.micro"
tags = {
Name = "controller"
}

key_name=aws_key_pair.web.id
vpc_security_group_ids=[ aws_security_group.ssh-access.id ]
}

resource "aws_key_pair" "web"{
public_key=file("my_key_pair.pub")
}


resource "aws_security_group" "ssh-access"{
name="ssh-access"
ingress{
from_port=22
to_port=22
protocol="tcp"
cidr_blocks=["0.0.0.0/0"]
}
}

output publicip {
value = aws_instance.webserver.public_ip
}
