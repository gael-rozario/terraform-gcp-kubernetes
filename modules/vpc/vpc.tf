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
resource "google_compute_router" "vpc-router" {
  name = "${var.env}-vpc-router"
  region = "${var.region}"
  network = "${var.vpc}"
  bgp {
    asn = 64514
    advertise_mode  = "CUSTOM"
    advertised_ip_ranges {
     range = "${var.private_subnet_cidr}"
    }
    advertised_ip_ranges {
     range = "${var.public_subnet_cidr}"
    }
  }
}
resource "google_compute_address" "nat_ip"{
  name = "${var.env}-nat-ip"
}
resource "google_compute_router_nat" "private-nat" {
  name = "${var.env}-private-nat"
  router = "${var.vpc_router_name}" 
  region = "${var.region}"
  nat_ip_allocate_option = "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name  = google_compute_subnetwork.private-subnet.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  nat_ips = [google_compute_address.nat_ip.self_link] 
}
output "vpc_name" {
  value = "${google_compute_network.vpc.name}"
}
output "vpc_router_name" {
  value = "${google_compute_router.vpc-router.name}"
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

