#first time creating terraform for aws vpc
#Providing account details

provider "aws" {
  region  "us-east-1"
  profile = "Terraform"
}

# creatig vpc
resource "aws_vpc" "Myvpc" {
  cidr_block = "10.0.0.0/16"


  tags = {
  Name = "FirstVPC"
  } 
}
