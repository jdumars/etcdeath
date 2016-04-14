resource "aws_placement_group" "etcdtest" {
    name = "etcdtest"
    strategy = "cluster"
}

resource "aws_autoscaling_group" "etcdtestasg" {
    availability_zones = ["us-east-1d"]
    name = "etcdtest-asg"
    max_size = 7
    min_size = 3
    health_check_grace_period = 300
    health_check_type = "EC2"
    desired_capacity = 3
    force_delete = false
    vpc_zone_identifier = ["${aws_subnet.public.id}"]
    placement_group = "${aws_placement_group.etcdtest.id}"
    launch_configuration = "${aws_launch_configuration.etcdtestasg_conf.name}"
    lifecycle {
      create_before_destroy = true
    }

  tag {
    key = "Name"
    value = "etcdtest-asg"
    propagate_at_launch = "true"
  }

}

resource "aws_launch_configuration" "etcdtestasg_conf" {
    name_prefix = "etcdtest-"
    image_id = "${var.coreos_ami}"
    instance_type = "${var.instance_size}"
    security_groups = ["${aws_security_group.etcdtest.id}"]
    key_name = "${var.ssh_key}"
    user_data = "${file("cloud-init.txt")}"
    lifecycle {
      create_before_destroy = true
    }

}
