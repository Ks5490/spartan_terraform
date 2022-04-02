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

  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file("/home/vagrant/.ssh/devops106_ksliwakk.pem")
  }

 provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -",
      "echo \"deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse\" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list",
      "sudo apt update",
      "sudo apt install -y mongodb-org",
      "sudo systemctl start mongod.service",
      ##"sudo systemctl status mongod",
      "sudo systemctl enable mongod",
      "mongo --eval 'db.runCommand({ connectionStatus: 1 })'",
      "sudo sed -i \"s/bindIp: 127.0.0.1/bindIp: 0.0.0.0/\" /etc/mongod.conf",
      
      "sudo systemctl restart mongod.service",
    ]
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

  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file("/home/vagrant/.ssh/devops106_ksliwakk.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get remove -y docker docker-engine docker.io containerd runc",
      "sudo apt-get update",
      "sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "sudo apt update",
      "sudo apt install -y docker-ce docker-ce-cli containerd.io",
      "sudo usermod -a -G docker ubuntu"
    ]
  }

   provisioner "local-exec" {
    command = "echo ${aws_instance.devops106_terraform_ksliwa_mongodb_tf.public_ip} > ./database.config"
  }

  provisioner "file" {
    source = "./database.config"
    destination = "/home/ubuntu/database.config"
    
  }

   provisioner "remote-exec" {
    inline = [
      "docker run -d hello-world",
      "ls -la /home/ubuntu",
      "cat /home/ubuntu/database.config"
    ]
  }    

  provisioner "remote-exec" {
    inline = [
      "docker pull ks5490/terraform_spartan_project:0.3 "
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "docker run -p 8080:8080 -v /home/ubuntu/database.config:/database.config  ks5490/terraform_spartan_project:0.3 "
    ]
  }
  
}


