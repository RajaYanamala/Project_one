provider "aws" {
    region = "ap-south-1"  
}

resource "aws_instance" "ProjectOne" {
  ami           = "ami-05552d2dcf89c9b24"
  instance_type = "t2.micro"
  key_name      = "Project_one_key"
  subnet_id     = aws_subnet.projectone-public-subnet-01.id

  vpc_security_group_ids = [aws_security_group.projectonesg.id]
}

resource "aws_security_group" "projectonesg" {
    name = "nameprojectonesg"
    description = "ssh accuss"
    vpc_id = aws_vpc.projectone-vpc.id 
  

  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "tagprojectone"
  }
}  

resource "aws_vpc" "projectone-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "projectone-vpc"
  }
  
}

resource "aws_subnet" "projectone-public-subnet-01" {
  vpc_id = aws_vpc.projectone-vpc.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "projectone-public-subent-01"
  }
}

resource "aws_subnet" "projectone-public-subnet-02" {
  vpc_id = aws_vpc.projectone-vpc.id
  cidr_block = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "projectone-public-subent-02"
  }
}

resource "aws_internet_gateway" "projectone-igw" {
  vpc_id = aws_vpc.projectone-vpc.id 
  tags = {
    Name = "projectone-igw"
  } 
}

resource "aws_route_table" "projectone-public-rt" {
  vpc_id = aws_vpc.projectone-vpc.id 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.projectone-igw.id 
  }
}

resource "aws_route_table_association" "projectone-rta-public-subnet-01" {
  subnet_id = aws_subnet.projectone-public-subnet-01.id
  route_table_id = aws_route_table.projectone-public-rt.id   
}

resource "aws_route_table_association" "projectone-rta-public-subnet-02" {
  subnet_id = aws_subnet.projectone-public-subnet-02.id 
  route_table_id = aws_route_table.projectone-public-rt.id   
}

