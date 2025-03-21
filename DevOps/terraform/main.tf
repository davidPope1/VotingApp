provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "web-app" {                 
  ami             = var.ami 
  instance_type   = var.instance_type
  tags = {
    Name = "MyWebApp"
    Description = "A web aoo hosted by docker on AWS"
  }

  user_data = file("./install-docker.sh")

  key_name        = var.key_name
  security_groups = [aws_security_group.web_sg.name]
}

resource "aws_security_group" "web_sg" {
  name          = "web-app-sg"
  description   = "Allow SSH and HTTP inbound traffic"

  # Allow SSH (optional, for debugging)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow frontend access (port 8000)
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow backend API access (port 5000)
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# http://13.49.225.91:8000   


# ssh -i web-access-key-pair.pem ec2-user@13.49.225.91 

# terraform apply -auto-approve

# docker-compose logs -f      // pt a vedea log urile de la comanda docker-compose up 

# docker ps

