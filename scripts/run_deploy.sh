#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Navigate to the Terraform directory
cd terraform

# Initialize Terraform (download necessary plugins)
terraform init

# Apply Terraform to provision the infrastructure
terraform apply -auto-approve

# Fetch the public IPs from Terraform output
public_ips=$(terraform output -json instance_public_ip | jq -r '.[]')

# Ensure the inventory directory exists
mkdir -p ../ansible/inventory

# Create the Ansible inventory file
echo "[web_app]" > ../ansible/inventory/hosts.ini

# Loop through the public IPs and add them to the inventory file
for ip in $public_ips; do
  echo "$ip ansible_ssh_user=ec2-user ansible_ssh_private_key_file=web-access-key-pair.pem" >> ../ansible/inventory/hosts.ini
done

echo "Ansible inventory file 'hosts.ini' has been created."

# Navigate to the Ansible directory
cd ../ansible

# Run the Ansible playbook to configure the EC2 instances
ansible-playbook -i inventory/hosts.ini playbooks/deploy.yml
