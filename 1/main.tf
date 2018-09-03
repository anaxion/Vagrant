provider "aws" {
  region     = "${var.region}"
}

module "vpc" {
  source = "./modules/vpc"
  tag =  "${var.tag}" 
  region = "${var.region}"
  name = "jm_ms"
}
