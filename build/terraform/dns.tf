resource "aws_route53_record" "bastion" {
  zone_id = "${var.zone_id}"
  name = "bastion.${var.domain}"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.bastion.public_ip}"]
}
