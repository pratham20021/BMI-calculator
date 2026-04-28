output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.bmi_ec2.id
}

output "public_ip" {
  description = "Public IP address of EC2 instance"
  value       = aws_instance.bmi_ec2.public_ip
}

output "app_url" {
  description = "Application URL"
  value       = "http://${aws_instance.bmi_ec2.public_ip}:${var.app_port}"
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.bmi_ecr.repository_url
}
