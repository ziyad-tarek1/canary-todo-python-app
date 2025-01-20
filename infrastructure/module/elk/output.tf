

output "helm_release_elasticsearch_name" {
  value = helm_release.elasticsearch.name
}

output "helm_release_logstash_name" {
  value = helm_release.logstash.name
}

output "helm_release_filebeat_name" {
  value = helm_release.filebeat.name
}


/*
output "helm_release_kibana_name" {
  value = helm_release.kibana.name
}

*/
