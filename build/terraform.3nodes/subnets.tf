resource "aws_subnet" "public" {
  cidr_block = "10.0.1.0/24"
  vpc_id = "${aws_vpc.etcdtest.id}"

  tags {
    Name = "public"
    Cluster = "${var.cluster}"
  }
}
