//// istio variables

variable "istio_base_name" {
    type = string
    default = "istio-base"
  
}

variable "istio_base_repo" {
    type = string
    default = "https://istio-release.storage.googleapis.com/charts"
  
}

variable "istio_base_chart" {
    type = string
    default = "base"
}



variable "istiod_name" {
    type = string
    default = "istiod"
  
}

variable "istiod_repo" {
    type = string
    default = "https://istio-release.storage.googleapis.com/charts"
  
}

variable "istiod_chart" {
    type = string
    default = "istiod"
}

variable "istio_namespace" {
    type = string
    default = "istio-system"
}

variable "istio_version" {
  type = string
  default = "1.18.2"
}


//// flagger variables



variable "flagger_name" {
    type = string
    default = "flagger"
  
}

variable "flagger_repo" {
    type = string
    default = "https://flagger.app"
  
}

variable "flagger_chart" {
    type = string
    default = "flagger"
}

variable "flagger_namespace" {
    type = string
    default = "flagger"
}

variable "flagger_version" {
  type = string
  default = "1.32.0"
}


variable "flagger_loadtester_name" {
    type = string
    default = "loadtester"
  
}

variable "flagger_loadtester_repo" {
    type = string
    default = "https://flagger.app"
  
}

variable "flagger_loadtester_chart" {
    type = string
    default = "loadtester"
  
}


variable "loadtester_version" {
    type = string
    default = "0.28.1"
  
}


