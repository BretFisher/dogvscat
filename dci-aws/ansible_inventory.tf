# Used in the md5 calculation for the EBS volume tagging.
# Ensures that we can find the drive and that it's unique.
resource "random_string" "aws_stack_id" {
  length  = 16
  special = false
}

locals {
  aws_efs_gp    = "${join("", aws_efs_file_system.cloudstor-gp.*.id)}"
  aws_efs_maxio = "${join("", aws_efs_file_system.cloudstor-maxio.*.id)}"
}

# Pass additional options
data "template_file" "extra_opts" {
  template = <<EOF
aws_region=$${region}
aws_dtr_storage_bucket=$${dtr_storage_bucket}

docker_ucp_license_path=$${ucp_license_path}
docker_ucp_admin_password=$${ucp_admin_password}

cloudstor_plugin_options="CLOUD_PLATFORM=AWS EFS_ID_REGULAR=$${efs_gp} EFS_ID_MAXIO=$${efs_maxio} EFS_SUPPORTED=$${efs_supported} AWS_STACK_ID=$${stack_id} AWS_REGION=$${region}"

docker_storage_volume="/dev/xvdb"
EOF

  vars {
    efs_gp             = "${local.aws_efs_gp}"
    efs_maxio          = "${local.aws_efs_maxio}"
    efs_supported      = "${var.efs_supported}"
    stack_id           = "${random_string.aws_stack_id.result}"
    region             = "${var.region}"
    dtr_storage_bucket = "${aws_s3_bucket.dtr_storage_bucket.id}"
    ucp_admin_password = "${local.ucp_admin_password}"
    ucp_license_path   = "${var.ucp_license_path}"
  }
}

data "template_file" "windows_worker_passwords" {
  count    = "${var.windows_ucp_worker_count}"
  template = "${rsadecrypt(element(aws_instance.ucp_worker_windows.*.password_data, count.index), file(var.private_key_path))}"
}

# Produce an inventory that can be read by ansible
module "inventory" {
  source         = "./modules/ansible"
  inventory_file = "${var.ansible_inventory}"

  linux_user               = "${var.linux_user}"
  windows_user             = "${var.windows_user}"
  windows_worker_passwords = "${data.template_file.windows_worker_passwords.*.rendered}"

  linux_ucp_manager_names = "${aws_instance.ucp_manager_linux.*.id}"
  linux_ucp_manager_ips   = "${aws_instance.ucp_manager_linux.*.public_ip}"

  linux_dtr_worker_names = "${aws_instance.ucp_worker_dtr.*.id}"
  linux_dtr_worker_ips   = "${aws_instance.ucp_worker_dtr.*.public_ip}"

  linux_worker_names = "${aws_instance.ucp_worker_linux.*.id}"
  linux_worker_ips   = "${aws_instance.ucp_worker_linux.*.public_ip}"

  windows_worker_names = "${aws_instance.ucp_worker_windows.*.id}"
  windows_worker_ips   = "${aws_instance.ucp_worker_windows.*.public_ip}"

  infra_stack = "aws"
  extra_vars  = "${data.template_file.extra_opts.rendered}"

  docker_ucp_lb = "${var.docker_ucp_lb == "" ? aws_elb.ucp.dns_name : var.docker_ucp_lb}"
  docker_dtr_lb = "${var.docker_dtr_lb == "" ? aws_elb.dtr.dns_name : var.docker_dtr_lb}"
}
