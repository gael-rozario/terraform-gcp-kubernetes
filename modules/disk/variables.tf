variable "name" {}
variable "project" {}
variable "env" {}
variable "type" {
  default = "pd-standard"
}
variable "zone" {}
variable "image" {}
variable "size" {
  default = 10
}
