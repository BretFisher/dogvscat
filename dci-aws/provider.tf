# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE ALL THE RESOURCES TO DEPLOY AN APP IN AN AUTO SCALING GROUP WITH AN ELB
# This template runs a simple "Hello, World" web server in Auto Scaling Group (ASG) with an Elastic Load Balancer
# (ELB) in front of it to distribute traffic across the EC2 Instances in the ASG.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ------------------------------------------------------------------------------

provider "aws" {
  version = "~> 1.13"

  region = "${var.region}"
}

# ---------------------------------------------------------------------------------------------------------------------
# GET THE LIST OF AVAILABILITY ZONES IN THE CURRENT REGION
# Every AWS accout has slightly different availability zones in each region. For example, one account might have
# us-east-1a, us-east-1b, and us-east-1c, while another will have us-east-1a, us-east-1b, and us-east-1d. This resource
# queries AWS to fetch the list for the current account and region.
# ---------------------------------------------------------------------------------------------------------------------

data "aws_availability_zones" "available" {}

# Use this data source to get the access to the effective Account ID, User ID, and ARN in which Terraform is authorized.
data "aws_caller_identity" "current" {}
