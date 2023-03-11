provider "aws" {
  alias = "third"
  region = "us-east-1"
  access_key = "AKIARP72LJ4GILBIGBMQ"
  secret_key = "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"
}
resource "aws_vpc" "vpc3" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "myvpc3"
  }
}

resource "aws_subnet" "vpc3_subnet1" {
  vpc_id = aws_vpc.vpc3.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "vpc3_subnet2" {
  vpc_id = aws_vpc.vpc3.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "vpc3_igw" {
  vpc_id = aws_vpc.vpc3.id
}

resource "aws_route_table" "vp3_rt" {
  vpc_id = aws_vpc.vpc3.id
}

resource "aws_route_table_association" "vpc3_rta1" {
  route_table_id = aws_route_table.vp3_rt.id
  subnet_id = aws_subnet.vpc3_subnet1.id
}

resource "aws_route_table_association" "vpc3_rta2" {
  route_table_id = aws_route_table.vp3_rt.id
  subnet_id = aws_subnet.vpc3_subnet2.id
}

resource "aws_security_group" "loadbalancer_sg" {
  name_prefix = "loadbalancer_sg"
  vpc_id = aws_vpc.vpc3.id
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

resource "aws_lb" "loadbalancer" {
  name = "myloadbalancer"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.loadbalancer_sg.id]

  subnet_mapping {
    subnet_id = aws_subnet.vpc3_subnet1.id
  }
  subnet_mapping {
    subnet_id = aws_subnet.vpc3_subnet2.id
  }
  depends_on = [
    aws_route_table_association.vpc3_rta1,
    aws_route_table_association.vpc3_rta2
  ]
}
