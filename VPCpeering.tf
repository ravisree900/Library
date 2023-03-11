provider "aws" {
  alias = "secondary"
  region = "ap-south-1"
  access_key = "AKIARP72LJ4GILBIGBMQ"
  secret_key = "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"
}

resource "aws_vpc" "vpc1" {
  cidr_block = "10.10.10.0/24"
  tags = {
    name = "myvpc1"
  }
}
resource "aws_vpc" "vpc2" {
  cidr_block = "192.0.0.0/24"
  tags = {
    name = "myvpc2"
  }
}
resource "aws_subnet" "subnet1" {
  vpc_id = "${aws_vpc.vpc1.id}"
  cidr_block = "10.10.10.0/25"
  availability_zone = "us-east-1b"
}
resource "aws_subnet" "subnet2" {
  vpc_id = "${aws_vpc.vpc2.id}"
  cidr_block = "192.0.0.0/25"
  availability_zone = "us-east-1a"
}
resource "aws_internet_gateway" "myigw1" {
  vpc_id = "${aws_vpc.vpc1.id}"
}
resource "aws_internet_gateway" "myigw2" {
  vpc_id = "${aws_vpc.vpc2.id}"
}
resource "aws_route_table" "myrt1" {
  vpc_id = "${aws_vpc.vpc1.id}"
}
resource "aws_route_table" "myrt2" {
  vpc_id = "${aws_vpc.vpc2.id}"
}
resource "aws_route_table_association" "myrta1" {
  route_table_id = aws_route_table.myrt1.id
  subnet_id = aws_subnet.subnet1.id
}
resource "aws_route_table_association" "myrta2" {
  route_table_id = aws_route_table.myrt2.id
  subnet_id = aws_subnet.subnet2.id
}
resource "aws_vpc_peering_connection" "vpc_peering" {
  provider = "aws"
  peer_vpc_id = aws_vpc.vpc2.id
  vpc_id      = aws_vpc.vpc1.id
  auto_accept = true
}
resource "aws_route" "vpc1tovpc2" {
  route_table_id = aws_route_table.myrt1.id
  destination_cidr_block = aws_vpc.vpc2.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}
resource "aws_route" "vpc2tovpc1" {
  route_table_id = aws_route_table.myrt2.id
  destination_cidr_block = aws_vpc.vpc1.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}