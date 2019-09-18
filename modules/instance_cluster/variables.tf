variable "instance_name" {}
variable "instance_count" {
  default = 1
}

variable "env" {}
variable "zone" {}
variable "region" {}
variable "type" {
  default = "f1-micro"
}
variable "subnet" {}
variable "tags" {
  type = "list"
}
variable "ansible_host" {}

variable "disk_type" {
   default = "pd-standard"
}
variable "image" {}
variable "disk_size" {
  default = 10
}
variable "project" {
  
}







