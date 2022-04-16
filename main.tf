provider "aws" {
  region  = "us-east-1"
  profile = "Terraform"
}


#create a vpc
resource "aws_vpc" "ownvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "myvpc"
  }
}

#create a public subnet

resource "aws_subnet" "publicsubnet" {

  vpc_id = aws_vpc.ownvpc.id

  cidr_block = "10.0.1.0/24"

  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "pub-sn"
  }
}


#create a private subnet

resource "aws_subnet" "privatesubnet" {
  vpc_id            = aws_vpc.ownvpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "pvt-sn"
  }
}

#create internetgateway

resource "aws_internet_gateway" "ownigw" {
  vpc_id = aws_vpc.ownvpc.id
  tags = {
    Name = "my-igw"
  }


#create a public route table
resource "aws_route_table" "publicroute" {
  vpc_id = aws_vpc.ownvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ownigw.id
  }
  tags = {
    Names = "pub-rt"
  }
}

#create public route table
resource "aws_route_table" "privateroute" {
  vpc_id = aws_vpc.ownvpc.id
  tags = {
    Name = "pvt-rt"
  }
}

#create subnet association
resource "aws_route_table_association" "pbsnaso" {
  subnet_id      = aws_subnet.publicsubnet.id
  route_table_id = aws_route_table.publicroute.id
}

resource "aws_route_table_association" "pvtsnaso" {
  subnet_id      = aws_subnet.privatesubnet.id
  route_table_id = aws_route_table.privateroute.id
}


#create securitygroups
resource "aws_security_group" "awssgp" {
  name = "sgpforall"

  #incomming traffic

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #outgoing traffic
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#launch a instance
resource "aws_instance" "web-instance" {
  ami           = "ami-0c02fb55956c7d316"
  subnet_id     = "subnet-0cd23973c71638561"
  instance_type = "t2.micro"
  key_name      = "north"

  tags = {
    Name = "terrafrom-ec2"
  }
}

