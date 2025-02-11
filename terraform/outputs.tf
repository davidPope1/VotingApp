output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.web-app.public_ip
}

output "instance_id" {
  value       = aws_instance.web-app.id
}