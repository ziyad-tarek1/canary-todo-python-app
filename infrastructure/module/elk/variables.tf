


variable "namespace" {
  default = "elk-stack"
}


variable "elasticsearch_chart_version" {
    default = "8.10.1"
}
variable "logstash_chart_version" {
    default = "8.10.1"
}
variable "filebeat_chart_version" {
    default = "8.10.1"
}
variable "kibana_chart_version" {
    default = "8.10.1"
}


variable "elasticsearchvalues_file" {}
variable "logstashvalues_file" {}
variable "filebeatvalues_file" {}
variable "kibanavalues_file" {}
variable "eks_dependency" {}