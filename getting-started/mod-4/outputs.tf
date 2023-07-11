output "public_dns_hostname" {
  value       = "Public DNS: http://${aws_instance.nginx1.public_dns}"
  description = "Public DNS hostname for EC2 instance"
}
