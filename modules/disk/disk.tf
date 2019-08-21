resource "google_compute_disk" "disk" {
  name  = "${var.env}-${var.name}"
  project = "${var.project}"
  type  = "${var.type}"
  zone  = "${var.zone}"
  image = "${var.image}"
  labels = {
    env = "${var.env}"
  }
  size = "${var.size}"
}
output "name" {
  value = "${google_compute_disk.disk.name}"
}
