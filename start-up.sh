#!/bin/bash

yum update -y
yum install -y httpd

systemctl start httpd
systemctl enable httpd

# Create a simple test webpage (optional)
echo "<h1>Hello, world!</h1>" > /var/www/html/index.html