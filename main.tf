terraform {
  backend "s3" {
    bucket         = "tenzin-io"
    key            = "terraform/homelab-k8s-oracle.state"
    dynamodb_table = "tenzin-io"
    region         = "us-east-1"
  }
}

module "cert_manager" {
  source                  = "git::https://github.com/tenzin-io/terraform-tenzin-cert-manager.git?ref=v0.0.2"
  cert_registration_email = "tenzin@tenzin.io"
  cloudflare_api_token    = chomp(data.aws_ssm_parameter.cloudflare_api_token.value)
}

module "github_actions" {
  source                     = "git::https://github.com/tenzin-io/terraform-tenzin-github-actions-runner-controller.git?ref=v0.0.1"
  github_org_name            = "tenzin-io"
  github_app_id              = chomp(data.aws_ssm_parameter.github_app_id.value)
  github_app_installation_id = chomp(data.aws_ssm_parameter.github_app_installation_id.value)
  github_app_private_key     = data.aws_ssm_parameter.github_app_private_key.value
  depends_on                 = [module.cert_manager]
}

module "nginx_ingress" {
  source             = "git::https://github.com/tenzin-io/terraform-tenzin-nginx-ingress-controller.git?ref=v0.0.3"
  nginx_service_type = "NodePort"
}

module "homelab_services" {
  source = "git::https://github.com/tenzin-io/terraform-tenzin-nginx-ingress-external.git?ref=v0.0.1"
  external_services = {
    "homelab-vsphere" = {
      virtual_host = "vs.tenzin.io"
      address      = "100.70.3.84"
      protocol     = "HTTPS"
      port         = "443"
    }
  }
  depends_on = [module.nginx_ingress, module.cert_manager]
}
