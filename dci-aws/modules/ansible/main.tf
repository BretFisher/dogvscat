# Split Primary and Replicas
locals {
  linux_ucp_manager_primary_name = "${element(var.linux_ucp_manager_names, 0)}" # Primary manager
  linux_ucp_manager_primary_ip   = "${element(var.linux_ucp_manager_ips, 0)}"   # Primary manager

  linux_ucp_manager_replica_names = "${slice(var.linux_ucp_manager_names, 1, length(var.linux_ucp_manager_names))}"
  linux_ucp_manager_replica_ips   = "${slice(var.linux_ucp_manager_ips, 1, length(var.linux_ucp_manager_ips))}"

  linux_dtr_worker_primary_name = "${element(var.linux_dtr_worker_names, 0)}" # Linux is always primary DTR
  linux_dtr_worker_primary_ip   = "${element(var.linux_dtr_worker_ips, 0)}"

  linux_dtr_worker_replica_names = "${slice(var.linux_dtr_worker_names, 1, length(var.linux_dtr_worker_names))}" # Linux DTR replica
  linux_dtr_worker_replica_ips   = "${slice(var.linux_dtr_worker_ips, 1, length(var.linux_dtr_worker_ips))}"     # Linux DTR replica

  load_balancers = "${var.docker_ucp_lb == "" ? "#" : ""}docker_ucp_lb=${var.docker_ucp_lb}\n${var.docker_dtr_lb == "" ? "#" : ""}docker_dtr_lb=${var.docker_dtr_lb}"
}

# Template for ansible inventory
data "template_file" "inventory" {
  template = "${file("${path.module}/inventory.tpl")}"

  vars {
    linux_manager_primary  = "${format("%s ansible_user=%s ansible_host=%s", local.linux_ucp_manager_primary_name, var.linux_user, local.linux_ucp_manager_primary_ip)}"
    linux_manager_replicas = "${join("\n", formatlist("%s ansible_user=%s ansible_host=%s", local.linux_ucp_manager_replica_names, var.linux_user, local.linux_ucp_manager_replica_ips))}"
    linux_dtr_primary      = "${format("%s ansible_user=%s ansible_host=%s", local.linux_dtr_worker_primary_name, var.linux_user, local.linux_dtr_worker_primary_ip)}"
    linux_dtr_replicas     = "${join("\n", formatlist("%s ansible_user=%s ansible_host=%s", local.linux_dtr_worker_replica_names, var.linux_user, local.linux_dtr_worker_replica_ips))}"
    linux_workers          = "${length(var.linux_worker_names) > 0 ? join("\n", formatlist("%s ansible_user=%s ansible_host=%s", var.linux_worker_names, var.linux_user, var.linux_worker_ips)) : ""}"

    windows_workers = "${length(var.windows_worker_names) > 0
				 ? join("\n", formatlist("%s ansible_host=%s ansible_user=${var.windows_user} ansible_password='%s'", var.windows_worker_names, var.windows_worker_ips, var.windows_worker_passwords))
				 : ""}"

    linux_ucp_lbs = "${length(var.linux_ucp_lb_names) > 0 ? join("\n", formatlist("%s ansible_user=%s ansible_host=%s", var.linux_ucp_lb_names, var.linux_user, var.linux_ucp_lb_ips)) : ""}"
    linux_dtr_lbs = "${length(var.linux_dtr_lb_names) > 0 ? join("\n", formatlist("%s ansible_user=%s ansible_host=%s", var.linux_dtr_lb_names, var.linux_user, var.linux_dtr_lb_ips)) : ""}"

    # extra configs
    linux_databases   = "${length(var.linux_database_names) > 0 ? join("\n", formatlist("%s ansible_user=%s ansible_host=%s", var.linux_database_names, var.linux_user, var.linux_database_ips)) : ""}"
    linux_build       = "${length(var.linux_build_server_names) > 0 ? join("\n", formatlist("%s ansible_user=%s ansible_host=%s", var.linux_build_server_names, var.linux_user, var.linux_build_server_ips)) : ""}"
    windows_databases = "${length(var.windows_database_names) > 0 ? join("\n", formatlist("%s ansible_host=%s", var.windows_database_names, var.windows_database_ips)) : ""}"
    windows_build     = "${length(var.windows_build_server_names) > 0 ? join("\n", formatlist("%s ansible_host=%s", var.windows_build_server_names, var.windows_build_server_ips)) : ""}"
    infra_stack       = "${var.infra_stack}"
    load_balancers    = "${local.load_balancers}"
    extra_vars        = "${var.extra_vars}"
  }
}

resource "local_file" "ansible_inventory" {
  content  = "${data.template_file.inventory.rendered}"
  filename = "${var.inventory_file}"
}
