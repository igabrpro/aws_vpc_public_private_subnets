# aws_vpc_public_private_subnets

This repo contains code taht creates VPC with two subnets one private and one public.

To use the code you need Terraform CLI installed 
Install Terraform - [instructions](https://www.terraform.io/downloads)


Repo content

vpc.tf - containing the VPC subnet ans route table configuraion
variable.tf - containing the variables
output.tf - this is the output date for the resources taht will be created
provider.tf - configure the aws provider 
security_group.tf - contains the security configuration 


Guide

    First download the repo https://github.com/igabrpro/ aws_vpc_public_private_subnets.git
    Change the directory cd  aws_vpc_public_private_subnets
    This repo is configured to be used as a module
    After module configuration has been complated 
    Execute terraform init in order to download the necessary providers
    Execute terraform apply in order to provision the code in main.tf

Expected result

    
    After applying the config you will have one VPC in AWS region taht has been specified in the config with two subnets one public and one private. The Security group will provide ssh acces and ping.
    
    
  ![Alt text](https://github.com/igabrpro/aws_vpc_public_private_subnets/blob/main/scr.png)

