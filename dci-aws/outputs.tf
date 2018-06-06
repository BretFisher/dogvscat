output "UCPDNSTarget" {
  description = "Use this name to update your DNS records"
  value       = "${aws_elb.ucp.dns_name}"
}

output "AppDNSTarget" {
  description = "Use this name to update your DNS records"
  value       = "${aws_elb.apps.dns_name}"
}

output "DTRDNSTarget" {
  description = "Use this name to update your DNS records"
  value       = "${aws_elb.dtr.dns_name}"
}
