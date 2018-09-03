# cidr for jm_vpc
variable "vpc_cidr" {
  default = "10.87.128.0/20"
}
# Public cidr

variable "public_cidr" {
  type = "list"
  default = ["10.87.129.0/24","10.87.131.0/24", "10.87.133.0/24"]
}
# Private cidr

variable "private_cidr" {
  type = "list"
  default = ["10.87.130.0/24","10.87.132.0/24", "10.87.134.0/24"]
}

variable "z_index" {
  description = "list of zones"
  type        = "list"
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "ami_iso" {
   type = "map"
   default = {
     us-east-1 = "ami-0422d936d535c63b1"
   }
}
variable "instance_type" {
  default = "t2.micro"
}
variable "name" {}
variable "tag" {}
variable "region" {}