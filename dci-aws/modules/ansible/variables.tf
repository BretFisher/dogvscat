# Ansible Inventory File Path
variable "inventory_file" {
  description = "Ansible-compatible inventory file used to store the list of hosts"
  default     = "hosts"
}

# Linux User
variable "linux_user" {
  description = "The user to setup and use within the Linux vm"
  default     = "docker"
}

# Windows User
variable "windows_user" {
  description = "The user to setup and use within the Windows vm"
  default     = "Administrator"
}

variable "windows_worker_passwords" {
  description = "The passwords to use within the Windows VMs"
  type        = "list"
}

# Linux UCP Managers
variable "linux_ucp_manager_names" {
  description = "The list of Linux UCP Manager names"
  type        = "list"
  default     = []
}

variable "linux_ucp_manager_ips" {
  description = "The list of Linux UCP Manager IPs"
  type        = "list"
  default     = []
}

# Linux DTR Workers
variable "linux_dtr_worker_names" {
  description = "The list of Linux DTR names"
  type        = "list"
  default     = []
}

variable "linux_dtr_worker_ips" {
  description = "The list of Linux DTR IPs"
  type        = "list"
  default     = []
}

# Linux Workers
variable "linux_worker_names" {
  description = "The list of Linux Worker names"
  type        = "list"
  default     = []
}

variable "linux_worker_ips" {
  description = "The list of Linux Worker IPs"
  type        = "list"
  default     = []
}

# Windows Workers
variable "windows_worker_names" {
  description = "The list of Windows Worker names"
  type        = "list"
  default     = []
}

variable "windows_worker_ips" {
  description = "The list of Windows Worker IPs"
  type        = "list"
  default     = []
}

## Extra Instances
# Linux Database Server
variable "linux_database_names" {
  description = "The list of Linux Database names"
  type        = "list"
  default     = []
}

variable "linux_database_ips" {
  description = "The list of Linux Database IPs"
  type        = "list"
  default     = []
}

# Linux Build Server
variable "linux_build_server_names" {
  description = "The list of Linux Build Server names"
  type        = "list"
  default     = []
}

variable "linux_build_server_ips" {
  description = "The list of Linux Build Server IPs"
  type        = "list"
  default     = []
}

# Windows Database Server
variable "windows_database_names" {
  description = "The list of Windows Database names"
  type        = "list"
  default     = []
}

variable "windows_database_ips" {
  description = "The list of Windows Database IPs"
  type        = "list"
  default     = []
}

# Windows Build Server
variable "windows_build_server_names" {
  description = "The list of Windows Build Server names"
  type        = "list"
  default     = []
}

variable "windows_build_server_ips" {
  description = "The list of Windows Build Server IPs"
  type        = "list"
  default     = []
}

# Load balancers

variable "docker_ucp_lb" {
  description = "UCP load balancer DNS name"
  default     = ""
}

variable "docker_dtr_lb" {
  description = "DTR load balancer DNS name"
  default     = ""
}

variable "linux_ucp_lb_ips" {
  description = "UCP load balancer IPs"
  default     = []
}

variable "linux_ucp_lb_names" {
  description = "UCP load balancer names"
  default     = []
}

variable "linux_dtr_lb_ips" {
  description = "DTR load balancer DNS name"
  default     = []
}

variable "linux_dtr_lb_names" {
  description = "DTR load balancer names"
  default     = []
}

# Additional vars
variable "infra_stack" {
  description = "The infra stack being deployed"
  default     = ""
}

variable "extra_vars" {
  description = "Any additional vars to add"
  default     = ""
}
