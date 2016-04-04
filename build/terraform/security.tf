resource "aws_security_group" "bastion" {
  name = "bastion"
  description = "Bastion for SSH access"
  vpc_id = "${aws_vpc.etcd.id}"

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
    Name = "bastion"
    Cluster = "${var.cluster}"
  }
}

resource "aws_security_group" "etcd" {
  name = "etcd"
  description = "etcd quorum"
  vpc_id = "${aws_vpc.etcd.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  ingress {
    from_port = "2379"
    to_port = "2380"
    protocol = "tcp"
    security_groups = ["${aws_security_group.etcd.id}"]
    self = true
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "etcd"
    Cluster = "${var.cluster}"
  }
}
