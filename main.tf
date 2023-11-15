# main.tf specs for Ubuntu Server & I also added the Linux 2 AMI but the code needs to be written into the main.tf file.
/*
This Terraform configuration file creates an AWS EC2 instance and an S3 bucket with ownership controls.

The EC2 instance is created with the following specifications:
- VPC ID: vpc-095a1ee516e12f7ba
- AWS REGION: eu-2-west
- AMI ID for Ubuntu: ami-0505148b3591e4c07
- AMI ID for Linux 2 AMI: ami-06d0baf788edae448
- Instance type: t2.micro
- Subnet ID: subnet-0394725cdbfd85d65 
- Tags: Name = "UbuntuServer"
- Tags: Name = "Linux2Server"
- key_name = "cpdevopsew-eu-west-2"
*/


resource "aws_security_group" "my_sg" {
  name        = "ubuntu_server_sg"
  description = "Allow SSH, HTTP, and HTTPS"
  vpc_id      = "vpc-095a1ee516e12f7ba"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_instance" "ubuntu_server" {
  ami                    = "ami-0505148b3591e4c07"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-0394725cdbfd85d65"
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  key_name               = "cpdevopsew-eu-west-2"

  tags = {
    Name = "UbuntuServerS3"
  }

}



resource "aws_instance" "amazon_linux2_server" {
  count                  = 2
  ami                    = "ami-06d0baf788edae448"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-0394725cdbfd85d65"
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  key_name               = "cpdevopsew-eu-west-2"

  tags = {
    Name = "AmazonLinux2Server-${count.index}"
  }

}

output "ubuntu_ec2_instance_ip" {
  value = aws_instance.ubuntu_server.public_ip
}

output "linux_ec2_instance_ip" {
  value = aws_instance.amazon_linux2_server.*.public_ip
}
