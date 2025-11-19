output "ec2_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.app_server.public_ip
}
