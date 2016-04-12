resource "aws_instance" "etcdbastion" {
  ami = "${var.coreos_ami}"
  associate_public_ip_address = true
  instance_type = "t2.micro"
  key_name = "${var.ssh_key}"
  subnet_id = "${aws_subnet.public.id}"
  vpc_security_group_ids = ["${aws_security_group.etcdbastion.id}"]

  tags {
    Name = "etcdbastion"
    Cluster = "${var.cluster}"
  }
}

resource "aws_instance" "etcd_test_01" {
  ami = "${var.coreos_ami}"
  associate_public_ip_address = true
  instance_type = "${var.instance_size}"
  key_name = "${var.ssh_key}"
  private_ip = "10.0.1.4"
  subnet_id = "${aws_subnet.public.id}"
  user_data = "${template_file.etcd_01_cloud_config.rendered}"
  vpc_security_group_ids = ["${aws_security_group.etcdtest.id}"]

  tags {
    Name = "etcd_test_01"
    Cluster = "${var.cluster}"
  }
}

resource "aws_instance" "etcd_test_02" {
  ami = "${var.coreos_ami}"
  associate_public_ip_address = true
  instance_type = "${var.instance_size}"
  key_name = "${var.ssh_key}"
  private_ip = "10.0.1.5"
  subnet_id = "${aws_subnet.public.id}"
  user_data = "${template_file.etcd_02_cloud_config.rendered}"
  vpc_security_group_ids = ["${aws_security_group.etcdtest.id}"]

  tags {
    Name = "etcd_test_02"
    Cluster = "${var.cluster}"
  }
}

resource "aws_instance" "etcd_test_03" {
  ami = "${var.coreos_ami}"
  associate_public_ip_address = true
  instance_type = "${var.instance_size}"
  key_name = "${var.ssh_key}"
  private_ip = "10.0.1.6"
  subnet_id = "${aws_subnet.public.id}"
  user_data = "${template_file.etcd_03_cloud_config.rendered}"
  vpc_security_group_ids = ["${aws_security_group.etcdtest.id}"]

  tags {
    Name = "etcd_test_03"
    Cluster = "${var.cluster}"
  }
}


resource "aws_instance" "etcd_test_04" {
  ami = "${var.coreos_ami}"
  associate_public_ip_address = true
  instance_type = "${var.instance_size}"
  key_name = "${var.ssh_key}"
  private_ip = "10.0.1.7"
  subnet_id = "${aws_subnet.public.id}"
  user_data = "${template_file.etcd_04_cloud_config.rendered}"
  vpc_security_group_ids = ["${aws_security_group.etcdtest.id}"]

  tags {
    Name = "etcd_test_04"
    Cluster = "${var.cluster}"
  }
}

resource "aws_instance" "etcd_test_05" {
  ami = "${var.coreos_ami}"
  associate_public_ip_address = true
  instance_type = "${var.instance_size}"
  key_name = "${var.ssh_key}"
  private_ip = "10.0.1.8"
  subnet_id = "${aws_subnet.public.id}"
  user_data = "${template_file.etcd_05_cloud_config.rendered}"
  vpc_security_group_ids = ["${aws_security_group.etcdtest.id}"]

  tags {
    Name = "etcd_test_05"
    Cluster = "${var.cluster}"
  }
}
