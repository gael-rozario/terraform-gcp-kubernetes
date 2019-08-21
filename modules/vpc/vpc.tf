resource "google_compute_network" "vpc" {
  auto_create_subnetworks = "false"
  name = "${var.env}-vpc"
  project = "${var.project}"
}
resource "google_compute_subnetwork" "private-subnet" {
  name = "${var.env}-private-subnet"
  region = "${var.region}"
  ip_cidr_range = "${var.private_subnet_cidr}"
  network = "${var.vpc}"
}
resource "google_compute_subnetwork" "public-subnet" {
  name = "${var.env}-public-subnet"
  region = "${var.region}"
  ip_cidr_range = "${var.public_subnet_cidr}"
  network = "${var.vpc}"
}
output "vpc_name" {
  value = "${google_compute_network.vpc.name}"
}
output "private_subnet_name" {
  value = "${google_compute_subnetwork.private-subnet.name}"
}
output "public_subnet_name" {
  value = "${google_compute_subnetwork.public-subnet.name}"
}
output "private_subnet_cidr" {
  value = "${google_compute_subnetwork.private-subnet.ip_cidr_range}"
}
output "public_subnet_cidr" {
  value = "${google_compute_subnetwork.public-subnet.ip_cidr_range}"
}



