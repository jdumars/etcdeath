resource "aws_subnet" "public" {
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1d"
  vpc_id = "${aws_vpc.etcdtest.id}"
  map_public_ip_on_launch = true
  tags {
    Name = "public"
    Cluster = "${var.cluster}"
  }
}
