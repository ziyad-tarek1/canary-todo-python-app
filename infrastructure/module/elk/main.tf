resource "kubernetes_namespace" "elk_stack" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  namespace  =  var.namespace  //"elk-stack"
  version    =   var.elasticsearch_chart_version              // "8.5.1"
  // values = var.elasticsearchvalues_file != "" ? [file(var.elasticsearchvalues_file)] : []
  values     = [file(var.elasticsearchvalues_file)]
  depends_on = [kubernetes_namespace.elk_stack, var.eks_dependency]
  timeout = "500"

}


resource "helm_release" "logstash" {
  name       = "logstash"
  repository = "https://helm.elastic.co"
  chart      = "logstash"
  namespace  = var.namespace  //"elk-stack"
  version    =  var.logstash_chart_version // "8.5.1"
  values     = [file(var.logstashvalues_file)]
  depends_on = [kubernetes_namespace.elk_stack, var.eks_dependency, helm_release.elasticsearch /*, helm_release.kibana*/]
  timeout = "500"


}


resource "helm_release" "filebeat" {
  name       = "filebeat"
  repository = "https://helm.elastic.co"
  chart      = "filebeat"
  namespace  = var.namespace  //"elk-stack"
  version    = var.filebeat_chart_version // "8.5.1"
  values     = [file(var.filebeatvalues_file)]
  depends_on = [kubernetes_namespace.elk_stack, var.eks_dependency , helm_release.elasticsearch , /*helm_release.kibana ,*/ helm_release.logstash]
  timeout = "500"



}



resource "helm_release" "kibana" {
  name       = "kibana"
  repository = "https://helm.elastic.co"
  chart      = "kibana" 
  namespace  = var.namespace   //"elk-stack"
  version    =  var.kibana_chart_version  // "8.5.1"
  values     = [file(var.kibanavalues_file)]
  depends_on = [kubernetes_namespace.elk_stack, var.eks_dependency , helm_release.elasticsearch ]
  timeout = "500"

}
