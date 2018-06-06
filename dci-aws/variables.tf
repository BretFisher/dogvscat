# Cloudstor requirement
variable "efs_supported" {
  description = "Set to '1' if the AWS region supports EFS, or 0 if not (see https://aws.amazon.com/about-aws/global-infrastructure/regional-product-services/)."
}

variable "vpc_id" {
  description = "If set, create sub-nets within a pre-existing VPC instead of creating a new one."
  default     = ""
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC created, or for the Docker EE allocation within an existing VPC. Another 4 bits will be used as the subnet ID, so a /22 is about the maximum possible."
  default     = "172.31.0.0/16"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "key_name" {
  description = "The name of the key pair to associate with the instance"
}

variable "private_key_path" {
  description = "The private key corresponding to 'key_name'"
}

# Linux nodes disk
variable "linux_manager_volume_size" {
  description = "The volume size in GB for Linux managers"
  default     = "100"
}

variable "linux_worker_volume_size" {
  description = "The volume size in GB for Linux workers"
  default     = "20"
}

variable "dtr_instance_volume_size" {
  description = "The volume size in GB for DTR instances"
  default     = "100"
}

# Windows nodes disk
variable "windows_worker_volume_size" {
  description = "The volume size in GB for Windows workers"
  default     = "100"
}

# AMIs
variable "linux_ami_owner" {
  description = "The OwnerID of the Linux AMI (from 'aws ec2 describe-images')"
  default     = "099720109477"
}

variable "linux_ami_name" {
  description = "Linux instances will use the newest AMI matching this pattern"
  default     = "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180306"
}

variable "windows_ami_owner" {
  description = "The OwnerID of the Windows AMI (from 'aws ec2 describe-images')"
  default     = "801119661308"
}

variable "windows_ami_name" {
  description = "Windows instances will use the newest AMI matching this pattern"
  default     = "Windows_Server-2016-English-Full-Containers-2017.11.29"
}
