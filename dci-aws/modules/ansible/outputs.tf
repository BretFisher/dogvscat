# Display inventory
output "hosts_content" {
  value = "${data.template_file.inventory.rendered}"
}

# Display inventory file location
output "hosts_file" {
  value = "Ansible hosts file location: ${var.inventory_file}"
}
