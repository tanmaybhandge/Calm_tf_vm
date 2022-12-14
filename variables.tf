variable "cluster_name" {
  type = string
}
variable "subnet_name" {
  type = string
}
variable "password" {
  type      = string
}
variable "endpoint" {
  type = string
}
variable "user" {
  type = string
}

variable "image_name" {
  type = string
  default = "ubuntu_final"
}
