variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1" # Default value
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-08b1d20c6a69a7100" # Default value
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro" # Default value
}

variable "key_name" {
  description = "The name of the AWS EC2 key pair to use for SSH access"
  type        = string
  default     = "david-aws-4-eu-north-1" # Optional default value
}