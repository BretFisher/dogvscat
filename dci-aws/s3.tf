# S3 Bucket:

resource "aws_s3_bucket" "dtr_storage_bucket" {
  bucket_prefix = "${lower(var.deployment)}-dtrstorage-"
  acl           = "private"

  tags {
    Name        = "${var.deployment}-DTRStorage"
    Environment = "${var.deployment}"
  }
}
