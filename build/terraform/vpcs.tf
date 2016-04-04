resource "aws_vpc" "etcdtest" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "etcdtest"
    Cluster = "${var.cluster}"
  }
}
