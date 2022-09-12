output "ec2instance" {
  description = "The public IP address of your EC2 instance"
  value       = "http://${aws_instance.preconfigured-gitlab.public_ip}/"
}

output "Info" {
  description = "This is only for informational purposes"
  value       = "Wait a minute or two until GitLab get's downloaded and installed."
}
