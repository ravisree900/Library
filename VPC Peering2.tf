provider "aws" {
  region = "us-east-1"
  access_key = "AKIARP72LJ4GGANATRPY"
  secret_key = "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"

}

resource "aws_vpc" "myvpc1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "myVPC1"
  }
}

resource "aws_subnet" "mysubnet1" {
  vpc_id     = aws_vpc.myvpc1.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "mySubnet1"
  }
}

resource "aws_vpc" "myvpc2" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "myVPC2"
  }
}

resource "aws_subnet" "mysubnet2" {
  vpc_id     = aws_vpc.myvpc2.id
  cidr_block = "192.168.1.0/24"
  tags = {
    Name = "mySubnet2"
  }
}
resource "aws_security_group" "sg_vpc1" {
  name_prefix = "sg_vpc1"
  vpc_id      = aws_vpc.myvpc1.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_vpc2" {
  name_prefix = "sg_vpc2"
  vpc_id      = aws_vpc.myvpc2.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "ravindra1" {
  ami           = "ami-0557a15b87f6559cf"
  instance_type = "t2.micro"
  key_name = "jannu"
  subnet_id     = aws_subnet.mysubnet1.id
  vpc_security_group_ids = [aws_security_group.sg_vpc1.id]
  associate_public_ip_address = true
  tags = {
    Name = "ravindra1"
  }
}

resource "aws_instance" "ravindra2" {
  ami           = "ami-005f9685cb30f234b"
  instance_type = "t2.micro"
  key_name = "jannu"
  subnet_id     = aws_subnet.mysubnet2.id
  vpc_security_group_ids = [aws_security_group.sg_vpc2.id]
  associate_public_ip_address = true
  tags = {
    Name = "ravindra2"
  }
}
