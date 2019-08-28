variable "instance_name" {}
variable "env" {}
variable "zone" {}
variable "region" {}
variable "type" {
  default = "f1-micro"
}
variable "subnet" {}
variable "boot_disk_name" {}
variable "public_ip" {}
variable "tags" {
  type = "list"
}
variable "ansible_host" {}





