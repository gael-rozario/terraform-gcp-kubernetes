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
resource "google_compute_router" "private-router" {
  name = "${var.env}-private-router"
  region = "${var.region}"
  network = "${var.vpc}"
  bgp {
    asn = 64514
  }
}
resource "google_compute_address" "nat_ip"{
  name = "${var.env}-nat-ip"
}
resource "google_compute_router_nat" "private-nat" {
  name = "${var.env}-private-nat"
  router = "${var.private-router}"
  region = "${var.region}"
  nat_ip_allocate_option = "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
        name  = "${var.private_subnet_name}"
        source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  nat_ips = []
}

output "vpc_name" {
  value = "${google_compute_network.vpc.name}"
}
output "private_router_name" {
  value = "${google_compute_router.private-router.name}"
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

output "nat_ip"{
  value = "${google_compute_address.nat_ip.address}"
} 


