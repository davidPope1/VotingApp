output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = [for instance in aws_instance.web-app : instance.public_ip]
}

output "instance_ids" {
  value = [for instance in aws_instance.web-app : instance.id]
}

output "vote_app_urls" {
  value = [for instance in aws_instance.web-app : "http://${instance.public_ip}:8080"]
}

output "result_app_urls" {
  value = [for instance in aws_instance.web-app : "http://${instance.public_ip}:8081"]
}