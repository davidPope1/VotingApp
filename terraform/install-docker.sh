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

# Configure Nginx to use the SSL certificates
sudo mkdir -p /etc/nginx/conf.d
sudo tee /etc/nginx/conf.d/votingapp.conf > /dev/null <<EOL
server {
    listen 80;
    server_name vote.linkpc.net www.vote.linkpc.net;
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl;
    server_name vote.linkpc.net www.vote.linkpc.net;

    ssl_certificate /etc/nginx/ssl/vote.linkpc.net.cer;
    ssl_certificate_key /etc/nginx/ssl/vote.linkpc.net.key;
    ssl_trusted_certificate /etc/nginx/ssl/ca.cer;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location /result {
        proxy_pass http://localhost:8081;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOL

# Start the application
docker-compose up --build

# Restart Nginx to apply the new configuration 
sudo systemctl restart nginx 