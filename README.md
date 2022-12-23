# **Final Project  - Two-Tier web application automation with Terraform**

## **Architecture**
The terraform code provisions the following architecture on AWS

![Architecture](./images/architecture.png)

## **Prerequisites**
The environment specific code is present under environments directory.


1. Clone the repository from github.
```
    $ git clone git@github.com:walexy10/Acs-Final-Project.git
```
2. Create SSH key pair to be used on virtual machines. A single key pair
   is used for all the environments.
```
   On AWS Console, go to Amazon S3 -> Key Pairs -> Create Key Pair
```  
3. Create S3 bucket for images and terraform backend state file. A separate bucket 
   is required to be created for each environment. Make the bucket public for all the environments.
```
   On AWS Console, go to Amazon S3 -> Buckets -> Create bucket
```  

4. Update bucket policy for each bucket
```
   On AWS Console, go to Amazon S3 -> Buckets -> Bucket -> Permissions -> Bucket policy
   and add this bucket policy
   
   
   {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::osaliu3finalproject/*"
        }
    ]
   }

    
    Replace <bucket_name> with actual environment bucket name
``` 

5. Update index.html with bucket name to be used for respective environment. 
```
   $ cd Acs-Final-Project.git/environments/dev/web
   Change <bucket_name> with actual bucket name
  
```   
6. Upload index.html and images to respective environment bucket
```
   On AWS Console, go to Amazon S3 -> Buckets -> Bucket Name -> Upload
  
``` 
7. Update bucket for terraform state file
```   
    For development environment, go to 
        $ cd Acs-Final-Project/environments/dev
        Update provider.tf with development bucket name
      
    For staging environment, go to 
        $ cd Acs-Final-Project/environments/staging
        Update provider.tf with staging bucket name
        
    For production environment, go to 
        $ cd Acs-Final-Project/environments/prod
        Update provider.tf with production bucket name
```

## **Steps to create development/staging/production environment**

1. Create development environment
```
   Run terraform init, plan and apply to create the environment
    $ cd environment/dev
    $ terraform init
    $ terraform plan
    $ terraform apply
    
   To destroy
    $ terraform destroy
```

2. Create staging environment
```
   Run terraform init, plan and apply to create the environment
    $ cd environment/staging
    $ terraform init
    $ terraform plan
    $ terraform apply
    
   To destroy
    $ terraform destroy
```

3. Create prod environment
```
   Run terraform init, plan and apply to create the environment
    $ cd environment/prod
    $ terraform init
    $ terraform plan
    $ terraform apply
    
   To destroy
    $ terraform destroy
```

## **Terraform Code Structure**
The environments directory is at root level and contains separate directories for development, production and stgaing.

- [**environments**]:
  - [dev]: This is the code for development environment.
  - [prod]: This is the code for production environment.
  - [staging]: This is the code for staging environment.
    - [bastion.tf]: Each environment contain bastion.tf that contains code to provision a bastion instance in public subnet.
    - [web]: The web directory under dev/staging/prod directory contains images and index.html that are required to uploaded to S3 bucket.

The modules directory is at root level and contains following modules.
- [**modules**]
  - [network]: This is network module that create VPC and other resources like subnets, internet gateway, nat gateway etc.
  - [secgrp]: This is secgrp module that creates security groups for web and load balancer subnet.
  - [asg]: This is asg module that container launch configuration and autoscaling group.
  - [alb]: This is application load balancer module to create load balanacer, listener, target group etc.

## **Code security scan**
The github actions workflow is enabled for security scan of code on push and pull requests. tfsec is being used for code scanning. 
The yaml file for code scan is present under .github/workflows/tfsec.yml
