provider "google" {
  credentials = "${file("~/.secret/angelic-bond-246708-f9ea847a05d2.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
  version     = "~> 2.13"
}

module "stage_vpc" {
  source = "../modules/vpc"
  env = "${var.env}"
  private_subnet_cidr = "10.10.0.0/17"
  public_subnet_cidr = "10.10.128.0/17"
  vpc = "${module.stage_vpc.vpc_name}"
  project = "${var.project}"
  private-router = "${module.stage_vpc.private_router_name}"
}
module "stage_vpc_internal_firewall" {
  source = "../modules/firewall"
  env = "${var.env}"
  name = "vpc-internal-firewall"
  network = "${module.stage_vpc.vpc_name}"
  portrange = ["0-65535"]
  source_ranges = ["${module.stage_vpc.private_subnet_cidr}","${module.stage_vpc.public_subnet_cidr}"]
  target_tags = []
}
module "stage-vpc-bastion-firewall" {
  source = "../modules/firewall"
  env = "${var.env}"
  name = "vpc-bastion-firewall"
  network = "${module.stage_vpc.vpc_name}"
  portrange = ["22"]
  source_ranges = ["0.0.0.0/0"]
  target_tags = "${module.ansible_instance.tags}"
}
module "ansible_disk" {
  source = "../modules/disk"
  project = "${var.project}"
  env = "${var.env}"
  name = "ansible-master"
  zone = "${var.region}-b"
  image = "ansible-master-image"
}
module "ansible_instance" {
  source = "../modules/instance"
  env = "${var.env}"
  instance_name = "ansible"
  type = "g1-small"
  region = "${var.region}"
  zone = "b"
  subnet = "${module.stage_vpc.public_subnet_name}"
  boot_disk_name = "${module.ansible_disk.name}"
  tags = ["bastion"]
  ansible_host = "bastion"
}
module "kubernetesmaster_instance" {
  source = "../modules/instance_cluster"
  env = "${var.env}"
  instance_count = 1
  type = "g1-small"
  project = "${var.project}"
  instance_name = "kubemaster"
  region = "${var.region}"
  zone = "b"
  subnet = "${module.stage_vpc.private_subnet_name}"
  tags = ["kubemaster"]
  ansible_host = "kubemaster"
  image = "ansible-base"
  public_ip = "${module.stage_vpc.nat_ips[0]}"
}
module "kubernetesworker_instance" {
  source = "../modules/instance_cluster"
  env = "${var.env}"
  instance_count = 2
  type = "g1-small"
  project = "${var.project}"
  instance_name = "kubeworkers"
  region = "${var.region}"
  zone = "b"
  subnet = "${module.stage_vpc.private_subnet_name}"
  tags = ["kubeworkers"]
  ansible_host = "kubeworkers"
  image = "ansible-base"
}
