resource "google_compute_firewall" "firewall" {
  name    = "${var.env}-${var.name}"
  network = "${var.network}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "${var.protocol}"
    ports    = "${var.portrange}"
  }
  source_ranges = "${var.source_ranges}"
  target_tags = "${var.target_tags}"
}
output "firewall" {
  value = "${google_compute_firewall.firewall.name}"
}
