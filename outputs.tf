

output "private_key" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
}

output "runner-instance-ip" {
  description = "The public ip for ssh access"
  value       = aws_instance.runner-instance.public_ip
}

output "ubunt_ami" {
  description = "The public ip for ssh access"
  value       = data.aws_ami.ubuntu
}
