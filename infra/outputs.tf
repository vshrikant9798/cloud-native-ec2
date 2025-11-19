output "ec2_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.app.public_ip
}
