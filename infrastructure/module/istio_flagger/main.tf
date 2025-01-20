resource "helm_release" "istio_base" {
  name =  var.istio_base_name //"istio-base"
  repository       =  var.istio_base_repo //"https://istio-release.storage.googleapis.com/charts"
  chart            =  var.istio_base_chart //"base"
  namespace        =  var.istio_namespace // "istio-system"
  create_namespace = true
  version          = var.istio_version //"1.18.2"
}

resource "helm_release" "istiod" {
  name = var.istiod_name

  repository       = var.istiod_repo
  chart            = var.istiod_chart
  namespace        = var.istio_namespace
  create_namespace = true
  version          = var.istio_version

  set {
    name  = "telemetry.enabled"
    value = "true"
  }

  depends_on = [helm_release.istio_base]
}


resource "helm_release" "flagger" {
  name = var.flagger_name

  repository       = var.flagger_repo
  chart            = var.flagger_chart
  namespace        = var.flagger_namespace
  create_namespace = true
  version          = var.flagger_version

  set {
    name  = "crd.create"
    value = "false"
  }

  set {
    name  = "meshProvider"
    value = "istio"
  }

  set {
    name  = "metricsServer"
   value = "http://prometheus-operated.monitoring.svc.cluster.local:9090"
  }
}


resource "helm_release" "loadtester" {
  name = var.flagger_loadtester_name

  repository       = var.flagger_loadtester_repo
  chart            = var.flagger_loadtester_chart
  namespace        = var.flagger_namespace
  create_namespace = true
  version          = var.loadtester_version
}