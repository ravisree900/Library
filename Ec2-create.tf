provider "aws" {
  region = "us-east-1"
  access_key = "AKIARP72LJ4GILBIGBMQ"
  secret_key = "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"
}
resource "aws_instance" "Servers" {
  ami = "ami-0557a15b87f6559cf"
  instance_type = "t2.micro"
  count = 3
  tags = {
    Name = "server"
  }
}
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "myvpc"
  }
}
resource "aws_subnet" "mysubnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.0.0/25"
  availability_zone = "us-east-1b"
  tags = {
    name = "mysubnet"
  }
}
resource "aws_internet_gateway" "my_gateway" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    name = "my_gateway"
  }
}
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gateway.id
  }
  tags = {
    name = "my_route_table"
  }
}
resource "aws_security_group" "my_security" {
  name = "my_security"
  vpc_id = aws_vpc.myvpc.id
  ingress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
}
resource "aws_route_table_association" "myassociation" {
  route_table_id = aws_route_table.my_route_table.id
  subnet_id = aws_subnet.mysubnet.id
}