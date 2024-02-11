locals {
  domain_name    = "${var.subdomain}.${var.dns_zone}"
  truststore     = join("", [data.http.cert_gov_ca_2018.response_body, data.http.cert_esteid.response_body])
  truststore_key = "truststore.pem"
}

data "http" "cert_gov_ca_2018" {
  url = "https://c.sk.ee/EE-GovCA2018.pem.crt"
}

data "http" "cert_esteid" {
  url = "https://c.sk.ee/esteid2018.pem.crt"
}

data "cloudflare_zone" "zone" {
  name = var.dns_zone
}

resource "cloudflare_record" "demo_dns" {
  zone_id = data.cloudflare_zone.zone.id
  name    = var.subdomain
  value   = aws_lb.demo.dns_name
  type    = "CNAME"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}