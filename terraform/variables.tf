variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI ID (update per region)"
  type        = string
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2023 us-east-1
}

variable "key_name" {
  description = "Name of the existing EC2 key pair"
  type        = string
}

variable "app_port" {
  description = "Port the Spring Boot app listens on"
  type        = number
  default     = 8080
}

variable "project_name" {
  description = "Tag prefix for all resources"
  type        = string
  default     = "bmi-app"
}
