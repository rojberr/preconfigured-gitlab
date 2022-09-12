output "ec2instance" {
  value       = "http://${aws_instance.preconfigured-gitlab.public_ip}"
  description = "The public IP address of your EC2 instance"
}
