output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.web-app.public_ip
}

output "instance_id" {
  value       = aws_instance.web-app.id
}

output "vote_app_url" {
  value = "http://${aws_instance.web-app.public_ip}:8080"
}

output "result_app_url" {
  value = "http://${aws_instance.web-app.public_ip}:8081"
}