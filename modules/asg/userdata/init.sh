#! /bin/bash

sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo chkconfig httpd on

# Get index.html from s3 bucket
sudo curl https://${s3_bucket_name}.s3.amazonaws.com/${html_file} -o ${html_path}/${html_file}