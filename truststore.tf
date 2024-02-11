resource "aws_s3_bucket" "truststore" {
  bucket = "demo-truststore-bucket"
}

resource "aws_s3_bucket_versioning" "truststore" {
  bucket = aws_s3_bucket.truststore.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "truststore" {
  bucket  = aws_s3_bucket.truststore.bucket
  key     = local.truststore_key
  content = local.truststore
  etag    = md5(local.truststore)
}

resource "aws_lb_trust_store" "demo" {
  name = "demo-truststore"

  ca_certificates_bundle_s3_bucket = aws_s3_bucket.truststore.bucket
  ca_certificates_bundle_s3_key    = aws_s3_object.truststore.key
}