# define our jm_vpc
resource "aws_vpc" "jm" {
  cidr_block = "${var.vpc_cidr}"
  tags {
    Name = "${var.name}.vpc"
    ita_group = "${var.tag}"
  }
}
# define our internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.jm.id}"
  tags {
   Name = "${var.name}.igw"
   ita_group = "${var.tag}"
  }
}
# define our subnets
resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.jm.id}"
  count = "${length(var.z_index)}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr, 4, count.index * 2)}"
  availability_zone = "${element(var.z_index, count.index)}"
  tags {
    Name = "${var.name}.public"
    ita_group = "${var.tag}"
  }
}
resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.jm.id}"
  count             = "${length(var.z_index)}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr, 4, count.index * 2 + 1)}"
  availability_zone = "${element(var.z_index, count.index)}"

  tags {
    Name = "${var.name}.private"
    ita_group = "${var.tag}"
  }
}
# define our route table
resource "aws_route_table" "jm_route" {
  vpc_id = "${aws_vpc.jm.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
    tags {
    Name = "${var.name}.route"
    ita_group = "${var.tag}"
    }
}
resource "aws_route_table_association" "jm_igw" {
  count          = "${length(var.z_index)}"
  route_table_id = "${aws_route_table.jm_route.id}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index )}"  
}
# Private routes
resource "aws_route_table_association" "jm_private" {
  count          = "${length(var.z_index)}"
  route_table_id = "${aws_route_table.jm_private.id}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index )}"
}
resource "aws_instance" "nat" {
  ami                         = "${lookup(var.ami_iso, var.region)}"
  instance_type               = "${var.instance_type}"
  security_groups             = ["${aws_security_group.nat_sg.id}"]
  subnet_id                   = "${aws_subnet.private.0.id}"
  associate_public_ip_address = true
  source_dest_check           = false
    tags {
    Name = "${var.name}.nat"
    ita_group = "${var.tag}"
  }
}
resource "aws_eip" "nat" {
  instance = "${aws_instance.nat.id}"
  vpc      = true
    tags {
    Name = "${var.name}.eip_nat"
    ita_group = "${var.tag}"
  }
}
# security groups
resource "aws_security_group" "nat_sg" {
  name        = "${var.name}.nat_sg"
  description = "NAT security group"
  vpc_id = "${aws_vpc.jm.id}"
  # Allow HTTP
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["10.87.129.0/20","10.87.131.0/20", "10.87.133.0/20" ]
  }
 # Allow HTTPS
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["10.87.130.0/20","10.87.132.0/20", "10.87.134.0/20" ]
  }
}
# Allow SHH
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow ICMP
  ingress {
    from_port = 0
    protocol = "icmp"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow all to out
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags {
    Name = "${var.name}.sgnat"
    ita_group = "${var.tag}"
}
resource "aws_route_table" "jm_private" {
  vpc_id     = "${aws_vpc.jm.id}"
  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }
  tags {
    Name = "${var.name}.route"
    ita_group = "${var.tag}"
  }
}