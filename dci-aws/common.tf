# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "deployment" {
  description = "The deployment name for this stack"
}

variable "region" {
  description = "Location/Region of resources deployed"
  default     = ""
}

variable "windows_user" {
  description = "The account to use for WinRM connections"
  default     = "Administrator"
}

variable "linux_user" {
  description = "The account to use for ssh connections"
}

variable "windows_admin_password" {
  description = "Windows worker password"
  default     = ""
}

resource "random_string" "windows_password" {
  length  = 16
  special = false

  keepers = {
    # Generate a new password only when a new deployment is defined
    deployment = "${var.deployment}"
  }
}

# 1. generate a random string
# 2. append a known string of mT4! which will satisfy 4 of the password complexity requirements:
#    i.   Contains an uppercase character
#    ii.  Contains a lowercase character
#    iii. Contains a numeric digit
#    iv.  Contains a special character
locals {
  windows_password = "${var.windows_admin_password == "" ? "${random_string.windows_password.result}mT4!" : var.windows_admin_password}"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

#######################
# UCP
#######################
## Manager details
variable "linux_manager_instance_type" {
  description = "The instance type for the managers"
  default     = ""
}

variable "linux_ucp_manager_count" {
  description = "Number of Manager nodes"
  default     = 3
}

## Linux worker details
variable "linux_worker_instance_type" {
  description = "The instance type for the Linux workers"
  default     = ""
}

variable "linux_ucp_worker_count" {
  description = "Number of Linux worker nodes"
  default     = 1
}

## Windows worker details
variable "windows_worker_instance_type" {
  description = "The instance type for the Windows workers"
  default     = ""
}

variable "windows_ucp_worker_count" {
  description = "Number of Windows worker nodes"
  default     = 1
}

#######################
# DTR
#######################
variable "dtr_instance_type" {
  description = "The instance type for the dtr nodes"
  default     = ""
}

variable "linux_dtr_count" {
  description = "Number of Linux DTR nodes"
  default     = 3
}

#######################
# Database nodes
#######################

variable "linux_database_count" {
  description = "Number of Linux database VMs. These VMs have resources specified separately."
  default     = 0
}

variable "windows_database_count" {
  description = "Number of Windows database VMs. These VMs have resources specified separately."
  default     = 0
}

#######################
# Build nodes
#######################

variable "linux_build_server_count" {
  description = "Number of Linux build server VMs. These VMs have resources specified separately."
  default     = 0
}

variable "windows_build_server_count" {
  description = "Number of Windows build server VMs. These VMs have resources specified separately."
  default     = 0
}

#######################
# Load Balancers
#######################

variable "docker_ucp_lb" {
  description = "UCP load balancer DNS name"
  default     = ""
}

variable "docker_dtr_lb" {
  description = "DTR load balancer DNS name"
  default     = ""
}

#######################
# Ansible
#######################

variable "ansible_inventory" {
  description = "Ansible-compatible inventory file used to store the list of hosts"
  default     = "inventory/1.hosts"
}

variable "ucp_license_path" {
  description = "UCP License path"
  default     = ""
}

variable "ucp_admin_password" {
  description = "UCP Admin password"
  default     = ""
}

resource "random_string" "ucp_password" {
  length  = 12
  special = false

  keepers = {
    # Generate a new password only when a new deployment is defined
    deployment = "${var.deployment}"
  }
}

locals {
  ucp_admin_password = "${var.ucp_admin_password == "" ? "${random_string.ucp_password.result}" : var.ucp_admin_password}"
}
