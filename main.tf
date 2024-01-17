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

}

resource "aws_instance" "new_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  user_data     = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                echo "<html><body><h1>Hello from AWS EC2!</h1></br><p>created by starcode</p></body></html>" > /var/www/html/index.html
                service httpd start
                chkconfig httpd on
              EOF

  tags = {
    Name = "ExampleInstance"
  }

  key_name               = "sample"
  vpc_security_group_ids = [aws_security_group.example_security_group.id]

}
