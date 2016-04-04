resource "aws_security_group" "etcdbastion" {
  name = "etcdbastion"
  description = "Bastion for etcd cluster SSH access"
  vpc_id = "${aws_vpc.etcdtest.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "etcdbastion"
    Cluster = "${var.cluster}"
  }
}

resource "aws_security_group" "etcdtest" {
  name = "etcdtest"
  description = "etcd test quorum"
  vpc_id = "${aws_vpc.etcdtest.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = ["${aws_security_group.etcdbastion.id}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "etcdtest"
    Cluster = "${var.cluster}"
  }
}
