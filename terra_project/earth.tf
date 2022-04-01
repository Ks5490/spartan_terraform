provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "devops106_terraform_ksliwa_vpc_tf" {
  cidr_block = "10.207.0.0/16"
  tags = {
    Name = "devops106_terraform_ksliwa_vpc"
  }
}

##Subnet for the application 
resource "aws_subnet" "devops106_terraform_ksliwa_subnet_webserver_tf" {
  vpc_id = aws_vpc.devops106_terraform_ksliwa_vpc_tf.id
  cidr_block = "10.207.101.0/24"
  tags = {
    Name = "devops106_terraform_ksliwa_subnet_webserver"
  }
}

## subnet for the database
resource "aws_subnet" "devops106_terraform_ksliwa_subnet_mongodb_tf" {
  vpc_id = aws_vpc.devops106_terraform_ksliwa_vpc_tf.id
  cidr_block = "10.207.202.0/24"
  tags = {
    Name = "devops106_terraform_ksliwa_subnet_mongodb"
  }
}

## route table for web app and mongodb
resource "aws_route_table" "devops106_terraform_ksliwa_rt_public_tf" {
  vpc_id = aws_vpc.devops106_terraform_ksliwa_vpc_tf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops106_terraform_ksliwa_igw_tf.id
  }
}

## route table associations 
resource "aws_route_table_association" "devops106_terraform_ksliwa_assoc_rt_public_subnet101_tf" {
  subnet_id = aws_subnet.devops106_terraform_ksliwa_subnet_webserver_tf.id
  route_table_id = aws_route_table.devops106_terraform_ksliwa_rt_public_tf.id
}
resource "aws_route_table_association" "devops106_terraform_ksliwa_assoc_rt_public_subnet202_tf" {
  subnet_id = aws_subnet.devops106_terraform_ksliwa_subnet_mongodb_tf.id
  route_table_id = aws_route_table.devops106_terraform_ksliwa_rt_public_tf.id
}

### internet gateway covers both subnets in vpc 
resource "aws_internet_gateway" "devops106_terraform_ksliwa_igw_tf" {
  vpc_id = aws_vpc.devops106_terraform_ksliwa_vpc_tf.id
  tags = {
    "Name" = "devops106_terraform_ksliwa_igw"
  }
}



#################################################################################################################



## Nacl for app - needs to allow any http/s or ssh ingress and mongodb egress
resource "aws_network_acl" "devops106_terraform_ksliwa_nacl_public_tf" {
  vpc_id = aws_vpc.devops106_terraform_ksliwa_vpc_tf.id
  subnet_ids = [aws_subnet.devops106_terraform_ksliwa_subnet_webserver_tf.id]
 ingress {
    rule_no = 100
    from_port = 22
    to_port = 22
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }
  
  ingress {
    rule_no = 200
    from_port = 8080
    to_port = 8080
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  ingress {
    rule_no = 10000
    from_port = 1024
    to_port = 65535
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }
  
  
  egress {
    rule_no = 100
    from_port = 80
    to_port = 80
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  egress {
    rule_no = 200
    from_port = 443
    to_port = 443
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }
  
  egress {
    rule_no = 10000
    from_port = 1024
    to_port = 65535
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }
  
  tags = {
    Name = "devops106_terraform_ksliwa_nacl_public"
  }
}


# Nacl for database 
resource "aws_network_acl" "devops106_terraform_ksliwa_nacl_mongodb_tf" {
  vpc_id = aws_vpc.devops106_terraform_ksliwa_vpc_tf.id
  subnet_ids = [aws_subnet.devops106_terraform_ksliwa_subnet_mongodb_tf.id]

   ingress {
    rule_no = 100
    from_port = 22
    to_port = 22
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }
  
  ingress {
    rule_no = 200
    from_port = 27017
    to_port = 27017
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }
  
  ingress {
    rule_no = 10000
    from_port = 1024
    to_port = 65535
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }
  
  
  egress {
    rule_no = 100
    from_port = 80
    to_port = 80
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  egress {
    rule_no = 200
    from_port = 443
    to_port = 443
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  egress {
    rule_no = 10000
    from_port = 1024
    to_port = 65535
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  tags = {
    Name = "devops106_terraform_ksliwa_nacl_public"
  }
}

## security group for web app
resource "aws_security_group" "devops106_terraform_ksliwa_sg_webserver_tf" {
  name = "devops106_terraform_ksliwa_sg_webserver"
  vpc_id = aws_vpc.devops106_terraform_ksliwa_vpc_tf.id

  ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
    
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
    }
}
## security group for mongodb
resource "aws_security_group" "devops106_terraform_ksliwa_sg_mongodb_tf" {
  name = "devops106_terraform_ksliwa_sg_mongo"
  vpc_id = aws_vpc.devops106_terraform_ksliwa_vpc_tf.id

   ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
      from_port = 27017
      to_port = 27017
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
      from_port = 0
      to_port = 0
      protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
    }
    

    tags = {
      "Name" = "devops106_terraform_ksliwa_sg_webserver"
    }
}


#instance for web app 
resource "aws_instance" "devops106_terraform_ksliwa_webserver_tf" {
  ami = "ami-08ca3fed11864d6bb"
  instance_type = "t2.micro"
  key_name = "devops106_ksliwa"
  vpc_security_group_ids = [aws_security_group.devops106_terraform_ksliwa_sg_webserver_tf.id]
  subnet_id = aws_subnet.devops106_terraform_ksliwa_subnet_webserver_tf.id
  associate_public_ip_address = true

  tags = {
    "Name" = "devops106_terraform_ksliwa_webserver"
  }
}


## instance for mongodb server 
resource "aws_instance" "devops106_terraform_ksliwa_mongodb_tf" {
  ami = "ami-08ca3fed11864d6bb"
  instance_type = "t2.micro"
  key_name = "devops106_ksliwa"
  vpc_security_group_ids = [aws_security_group.devops106_terraform_ksliwa_sg_mongodb_tf.id]
  subnet_id = aws_subnet.devops106_terraform_ksliwa_subnet_mongodb_tf.id
  associate_public_ip_address = true

  tags = {
    "Name" = "devops106_terraform_ksliwa_mongodb_server"
  }
}

output "database_ip" {
  value = aws_instance.devops106_terraform_ksliwa_mongodb_tf.public_ip
}

resource "local_file" "ip_file" {
  content  = aws_instance.devops106_terraform_ksliwa_mongodb_tf.public_ip
  filename = "ip_file.txt"
}
  
