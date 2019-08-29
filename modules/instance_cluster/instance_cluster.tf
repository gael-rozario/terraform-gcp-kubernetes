resource "google_compute_instance" "instance" {
    count = "${var.instance_count}"
    name = "${var.env}-${var.instance_name}-${count.index+1}"
    zone = "${var.region}-${var.zone}"
    machine_type  = "${var.type}"
    network_interface {
      subnetwork = "${var.subnet}"
      access_config {
        nat_ip = "${var.public_ip}"
    }
    }
    boot_disk{
        initialize_params{
            size = "${var.disk_size}"
            type = "${var.disk_type}"
            image = "${var.image}"
        }
    }
    labels = {
      ansible_host= "${var.ansible_host}"
    }
}