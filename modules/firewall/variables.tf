variable "name" {}
variable "env" {}
variable "network" {}
variable "protocol" {
    default = "tcp"
}
variable "portrange" {
    type    = "list"
}
variable "source_ranges" {
  type = "list"
}
variable "target_tags" {
  type = "list"
}




