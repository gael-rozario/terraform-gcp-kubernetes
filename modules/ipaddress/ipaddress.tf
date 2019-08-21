resource "google_compute_address" "ip_address" {
  name = "${var.name}"
}
output "ipaddress" {
  value = "${google_compute_address.ip_address.address}"
}
