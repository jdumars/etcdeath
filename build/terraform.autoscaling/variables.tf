variable "coreos_ami" {
  description = "The AMI ID for the CoreOS image to use for servers, e.g. `ami-1234abcd`"
}

variable "cluster" {
  description = "The target cluster's name"
}

variable "domain" {
  description = "The domain name for the cluster"
}

variable "instance_size" {
  description = "The EC2 instance size"
}

variable "ssh_key" {
  description = "Name of the SSH key in AWS that should have acccess to EC2 instances"
}

variable "zone_id" {
  description = "Zone ID of the Route 53 hosted zone"
}
