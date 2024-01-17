terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Set your desired AWS region
}

resource "aws_security_group" "example_security_group" {

  name        = "example-security-group"
  description = "Example security group for EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from any IP
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from any IP
  }

  egress {
    description = "Outbound rules"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "new_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  user_data     = <<-EOF
    #!/bin/bash

    yum update -y
    yum install -y httpd

    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello, world! From EC2</h1>" > /var/www/html/index.html
EOF

  tags = {
    Name = "ExampleInstance"
  }

  key_name               = "sample"
  vpc_security_group_ids = [aws_security_group.example_security_group.id]

}

# Output the public IP address for easy access
output "public_ip" {
  value = aws_instance.new_instance.public_ip
}


