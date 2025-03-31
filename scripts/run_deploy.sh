#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Install jq if not already installed
sudo apt update && sudo apt install -y jq

# Navigate to the Terraform directory
cd ../terraform

# Asign correct permissions to the key pair file so ansible accepts it to SSH 
chmod 400 web-access-key-pair.pem

# Initialize Terraform (download necessary plugins)
terraform init

# Apply Terraform to provision the infrastructure
terraform apply -auto-approve

# Wait for instances to fully initialize
echo "Waiting 60 seconds for instances to boot..."
sleep 90

# Fetch the public IPs from Terraform output
public_ips=$(terraform output -json instance_public_ip | jq -r '.[]')

# Ensure the inventory directory exists
mkdir -p ../ansible/inventory

# Create the Ansible inventory file
echo "[web_app]" > ../ansible/inventory/hosts.ini

# Loop through the public IPs and add them to the inventory file
for ip in $public_ips; do
  echo "$ip ansible_ssh_user=ec2-user ansible_ssh_private_key_file=../terraform/web-access-key-pair.pem ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> ../ansible/inventory/hosts.ini
done

echo "Ansible inventory file 'hosts.ini' has been created."

# Navigate to the Ansible directory
cd ../ansible

# Run the Ansible playbook to configure the EC2 instances
ansible-playbook -i inventory/hosts.ini playbooks/deploy.yml
