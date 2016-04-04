resource "aws_route53_record" "etcdbastion" {
  zone_id = "${var.zone_id}"
  name = "etcdbastion.${var.domain}"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.etcdbastion.public_ip}"]
}
