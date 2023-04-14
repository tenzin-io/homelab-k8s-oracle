provider "aws" {
  region = "us-east-1"
}

provider "helm" {
  kubernetes {
    config_path = "kubernetes-admin.conf"
  }
}

provider "kubernetes" {
  config_path = "kubernetes-admin.conf"
}
