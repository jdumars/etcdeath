resource "aws_instance" "etcdbastion" {
  ami = "${var.coreos_ami}"
  associate_public_ip_address = true
  instance_type = "t2.micro"
  key_name = "${var.ssh_key}"
  subnet_id = "${aws_subnet.public.id}"
  vpc_security_group_ids = ["${aws_security_group.etcdbastion.id}"]
  availability_zone = "us-east-1d"

  tags {
    Name = "etcdbastion"
    Cluster = "${var.cluster}"
  }
}

