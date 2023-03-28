provider "aws" {
  region = "ap-south-1"
  access_key = "AKIA3MICQOWUKKASCKSG"
  secret_key = "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"
}

resource "aws_instance" "ravindra" {
  ami = "ami-02eb7a4783e7e9317"
  instance_type = "t2.micro"
  key_name = "dhatri"
  count = 2
  tags = {
    Name = "ravindra-${count.index + 1}"
  }
}
