resource "helm_release" "istio_base" {
  name = "istio-base"

  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  namespace        = "istio-system"
  create_namespace = true
  version          = "1.18.2"
}

resource "helm_release" "istiod" {
  name = "istiod"

  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  namespace        = "istio-system"
  create_namespace = true
  version          = "1.18.2"

  set {
    name  = "telemetry.enabled"
    value = "true"
  }

  depends_on = [helm_release.istio_base]
}


resource "helm_release" "flagger" {
  name = "flagger"

  repository       = "https://flagger.app"
  chart            = "flagger"
  namespace        = "flagger"
  create_namespace = true
  version          = "1.32.0"

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
    value = "http://prometheus-operated.monitoring:9090"
  }
}


resource "helm_release" "loadtester" {
  name = "loadtester"

  repository       = "https://flagger.app"
  chart            = "loadtester"
  namespace        = "flagger"
  create_namespace = true
  version          = "0.28.1"
}