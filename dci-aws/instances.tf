# ---------------------------------------------------------------------------------------------------------------------
# CREATE ALL INSTANCES FOR MANAGERS, DTR AND WORKERS
# ---------------------------------------------------------------------------------------------------------------------

data "aws_ami" "linux_ami" {
  most_recent = true

  filter {
    name   = "owner-id"
    values = ["${var.linux_ami_owner}"]
  }

  filter {
    name   = "name"
    values = ["${var.linux_ami_name}"]
  }
}

data "aws_ami" "windows_ami" {
  most_recent = true

  filter {
    name   = "platform"
    values = ["windows"]
  }

  filter {
    name   = "owner-id"
    values = ["${var.windows_ami_owner}"]
  }

  filter {
    name   = "name"
    values = ["${var.windows_ami_name}"]
  }
}

# UCP Manager Instances:
#
resource "aws_instance" "ucp_manager_linux" {
  count = "${var.linux_ucp_manager_count}"

  ami                  = "${data.aws_ami.linux_ami.image_id}"
  instance_type        = "${var.linux_manager_instance_type}"
  key_name             = "${var.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.dtr_instance_profile.id}"
  subnet_id            = "${element(aws_subnet.pubsubnet.*.id, count.index)}"

  # Second disk for docker storage
  ebs_block_device {
    device_name           = "/dev/xvdb"
    volume_size           = "${var.linux_manager_volume_size}"
    volume_type           = "gp2"
    delete_on_termination = true
  }

  vpc_security_group_ids = ["${aws_security_group.ddc.id}"]

  # availability_zone = "${element(split(",", var.availability_zones), count.index) }"

  tags {
    Name = "${format("%s-Manager-Linux-%s", var.deployment, "${count.index + 1}")}"
  }
}

# UCP Worker Instances:
#
# Linux Workers:
#
resource "aws_instance" "ucp_worker_linux" {
  count = "${var.linux_ucp_worker_count}"

  ami                  = "${data.aws_ami.linux_ami.image_id}"
  instance_type        = "${var.linux_worker_instance_type}"
  key_name             = "${var.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.dtr_instance_profile.id}"
  subnet_id            = "${element(aws_subnet.pubsubnet.*.id, count.index)}"

  # Second disk for docker storage
  ebs_block_device {
    device_name           = "/dev/xvdb"
    volume_size           = "${var.linux_worker_volume_size}"
    volume_type           = "gp2"
    delete_on_termination = true
  }

  vpc_security_group_ids = ["${aws_security_group.ddc.id}"]

  # availability_zone = "${element(split(",", var.availability_zones), count.index) }"

  tags {
    Name = "${format("%s-Worker-Linux-%s", var.deployment, "${count.index + 1}")}"
  }
}

# Windows Workers:
#
resource "aws_instance" "ucp_worker_windows" {
  count = "${var.windows_ucp_worker_count}"

  ami                  = "${data.aws_ami.windows_ami.image_id}"
  instance_type        = "${var.windows_worker_instance_type}"
  key_name             = "${var.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.dtr_instance_profile.id}"
  subnet_id            = "${element(aws_subnet.pubsubnet.*.id, count.index)}"

  # Second disk for docker storage
  ebs_block_device {
    device_name           = "/dev/xvdb"
    volume_size           = "${var.windows_worker_volume_size}"
    volume_type           = "standard"
    delete_on_termination = true
  }

  vpc_security_group_ids = ["${aws_security_group.ddc.id}"]

  # availability_zone = "${element(split(",", module.net.zones), count.index) }"

  tags {
    Name = "${format("%s-Worker-Windows-%s", var.deployment, "${count.index + 1}")}"
  }
  get_password_data = "true"
  connection {
    type     = "winrm"
    user     = "${var.windows_user}"
    password = "${rsadecrypt(self.password_data, file(var.private_key_path))}"
    timeout  = "15m"
  }
  provisioner "file" {
    source      = "setup-windows.ps1"
    destination = "C:/WINDOWS/TEMP/setup-windows.ps1"
  }
  provisioner "remote-exec" {
    inline = ["powershell C:/WINDOWS/TEMP/setup-windows.ps1"]
  }
  user_data = <<EOF
<powershell>
  $VerbosePreference="Continue"
  winrm quickconfig -q
  winrm set winrm/config/service/Auth '@{Basic="true"}'
  winrm set winrm/config/client/auth '@{Basic="true"}'
  winrm set winrm/config/service '@{AllowUnencrypted="true"}'
  winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="1024"}'

  # Configure firewall to allow WinRM. Terraform will be able to connect after this (so do it last).
  netsh advfirewall firewall add rule name="WinRM in" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow
  $ansibleConfigurationScript = ((New-Object System.Net.Webclient).DownloadString('https://download.docker.com/winrm/scripts/ConfigureRemotingForAnsible.ps1'))
  Invoke-Command -ScriptBlock ([scriptblock]::Create($ansibleConfigurationScript)) -ArgumentList $env:COMPUTERNAME, 1095, $true, $false, $true, $false, $false
</powershell>
EOF
  timeouts {
    create = "1h"
  }
}

# DTR Instances:
#
resource "aws_instance" "ucp_worker_dtr" {
  count = "${var.linux_dtr_count}"

  ami                  = "${data.aws_ami.linux_ami.image_id}"
  instance_type        = "${var.linux_manager_instance_type}"
  key_name             = "${var.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.dtr_instance_profile.id}"
  subnet_id            = "${element(aws_subnet.pubsubnet.*.id, count.index)}"

  # Second disk for docker storage
  ebs_block_device {
    device_name           = "/dev/xvdb"
    volume_size           = "${var.dtr_instance_volume_size}"
    volume_type           = "gp2"
    delete_on_termination = true
  }

  vpc_security_group_ids = ["${aws_security_group.ddc.id}"]

  # availability_zone = "${element(split(",", var.availability_zones), count.index) }"

  tags {
    Name = "${format("%s-Worker-DTR-%s", var.deployment, "${count.index + 1}")}"
  }
}
