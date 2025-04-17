provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "web-app" {
  count           = var.instance_count                 
  ami             = var.ami 
  instance_type   = var.instance_type
  tags = {
    Name = "MyWebVotingApp"
    Description = "A voting web app hosted by Docker on AWS"
  }

#  user_data = file("./deploy.sh")

  key_name        = var.key_name
  security_groups = [aws_security_group.web_sg.name]
}

resource "aws_security_group" "web_sg" {
  name          = "voting-web-app-sg"
  description   = "Allow SSH and HTTP inbound traffic"

  # Allow SSH (optional, for debugging)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS (port 443)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow frontend access (port 8080 and 8081)
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Prometheus (port 9090)
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Grafana (port 3000)
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow cAdvisor (port 8085)
  ingress {
    from_port   = 8085
    to_port     = 8085
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

# 	vote.linkpc.net     http://13.60.54.109:8080    

# ssh -i web-access-key-pair.pem ec2-user@16.170.215.93        # 13.60.54.109

# http://51.21.130.93:8080       https://vote.linkpc.net        https://vote.linkpc.net/result

# terraform apply -auto-approve

# docker-compose logs -f      // pt a vedea log urile de la comanda docker-compose up 

# docker ps

# cd healthchecks / sudo chown ec2-user:ec2-user redis.sh / sudo chown ec2-user:ec2-user postgres.sh / chmod +x redis.sh / chmod +x postgres.sh

# docker-compose down / up --build 

# sudo cat /var/log/cloud-init-output.log     - comanda pt a accesa log urile ec2 ului    //problem cu nginx 

# nslookup vote.linkpc.net    // pt a verifica daca pointeaza dnsu la ipu ec2 instance-ului 

# sudo systemd-resolve --flush-caches       // pt a da flush la DNS cache 

# sudo systemctl start nginx 

# ca sa dam clear la browsing cache pe edge intram la alea 3 pct de sus dam settings si dam pe stanga la Privacy,search and serviecs si sub clear browsing data dam pe choose what to clear selectam cached images and files si coockes and other site data si dam clear now 
# dupa intram pe edge://net-internals/#hsts si sub Delete domain security policies bagam vote.linkpc.net la Domain si dam Delete 

# git restore . && git clean -df  && git pull origin main    ca sa dam discard la schimbarile locale si sa ne asiguram ca suntem up to date cu repo-ul 

# mai e o manevra cand intram in conflicte de cacat: $ git fetch origin $ git reset --hard origin/main $ git pull origin main 

# sa zicem ca dam docker-compose up in repo pe ubuntu direct fara deploy pe aws !!!

# sudo apt update  si  sudo apt upgrade -y  si  sudo apt install -y docker.io git nginx

# sudo chown david:david healthchecks/redis.sh  si  sudo chown david:david healthchecks/postgres.sh
# chmod +x healthchecks/redis.sh  si  chmod +x healthchecks/postgres.sh

# in grafana la mergem la Connections -> Data sources si cautam in lista Prometheus si la URL punem http://prometheus:9090 si dupa dam setup dashboard si avem mai multe variante https://github.com/sohammohite/container-monitoring/blob/main/dashboard.json ori ID-ul 1860 sau 14282

# ANSIBLE

# sudo apt update     sudo apt install -y ansible 

# chmod +x scripts/run_deploy.sh    // ca sa ne asiguram ca este executable(are permisiuni de executie) si dupa putem rula scriptu in terminal, deschis in folderu scripts, asa:

# ./run_deploy.sh