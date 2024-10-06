output "private_key" {
  value     = tls_private_key.instance_key.private_key_pem
  sensitive = true
}

output "create-ssh-key-cmd" {
  description = "Creates the ssh private key"
  value       = <<EOT
    terraform output -raw private_key > ~/.ssh/${local.project-name}
    sudo chmod 400 ~/.ssh/${local.project-name}
  EOT
}

output "ssh-into-machine" {
  description = "Opens SSH connection to the machine"
  value       = "ssh ubuntu@${aws_instance.runner_instance.public_ip} -i ~/.ssh/${local.project-name}"
}
