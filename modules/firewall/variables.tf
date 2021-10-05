variable "rule_name" {}
variable "network_name" {}
variable "protocol" {}
variable "port" {}
variable "tag" {}
variable "ranges_source" {
  type = list(string)
}
