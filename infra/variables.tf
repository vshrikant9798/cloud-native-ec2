variable "aws_region" {
  default = "ap-south-1"
}

variable "ecr_repo_name" {
  default = "bookstore-ec2"
}

variable "key_name" {
  default = "deploy-key"
}

variable "public_key_path" {
  default = "../deploy_key.pub"
}

variable "ami_id" {
  default = "ami-0dee22c13ea7a9a67"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "vpc_id" {
  default = "vpc-067ae3764c4ccd70a"
}

variable "subnet_id" {
  default = "subnet-0c028d3ed609dce6b"
}

variable "name_prefix" {
  default = "bookstore"
}