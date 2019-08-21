resource "google_compute_instance" "instance" {
    name = "${var.env}-${var.instance_name}"
    zone = "${var.region}-${var.zone}"
    machine_type  = "${var.type}"
    network_interface {
      subnetwork = "${var.subnet}"
      access_config {
        nat_ip = "${var.public_ip}"
    }
    }
    boot_disk  {
        source = "${var.boot_disk_name}"
    }
    tags = "${var.tags}"
}
output "tags" {
  value = "${google_compute_instance.instance.tags}"
}
