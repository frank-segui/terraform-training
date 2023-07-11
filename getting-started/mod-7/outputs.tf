output "aws_alb_public_dns" {
  value       = "Public DNS: http://${aws_lb.nginx.dns_name}"
  description = "Public DNS hostname for EC2 instance"
}
