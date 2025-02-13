#!/bin/bash
sudo yum update -y
sudo yum install -y docker git nginx 
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Clone your repository
cd /home/ec2-user
git clone https://github.com/davidPope1/VotingApp.git

# Change ownership and permissions of health check scripts
sudo chown ec2-user:ec2-user /home/ec2-user/VotingApp/healthchecks/redis.sh
sudo chown ec2-user:ec2-user /home/ec2-user/VotingApp/healthchecks/postgres.sh
chmod +x /home/ec2-user/VotingApp/healthchecks/redis.sh
chmod +x /home/ec2-user/VotingApp/healthchecks/postgres.sh

# Navigate into the cloned repository directory
cd VotingApp

# Move SSL certificates to the appropiate folder
sudo mkdir -p /etc/nginx/ssl
sudo cp ssl/vote.linkpc.net.cer /etc/nginx/ssl/
sudo cp ssl/vote.linkpc.net.key /etc/nginx/ssl/
sudo cp ssl/ca.cer /etc/nginx/ssl/

# Move Nginx configuration files to the appropiate folder 
sudo cp nginx.conf /etc/nginx/nginx.conf
sudo cp nginx/votingapp.conf /etc/nginx/conf.d/votingapp.conf

# Start the application
docker-compose up --build

# Restart Nginx to apply the new configuration 
sudo systemctl restart nginx 