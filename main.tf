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
  cloudflare_api_token    = data.vault_generic_secret.cloudflare.data.api_token
}

module "github_actions" {
  source                     = "git::https://github.com/tenzin-io/terraform-tenzin-github-actions-runner-controller.git?ref=v0.2.0"
  github_org_name            = "tenzin-io"
  github_app_id              = data.vault_generic_secret.github.data.app_id
  github_app_installation_id = data.vault_generic_secret.github.data.installation_id
  github_app_private_key     = data.vault_generic_secret.github.data.private_key
  github_runner_image        = "summerwind/actions-runner-dind:ubuntu-22.04"
  github_runner_labels       = ["oracle"]
  depends_on                 = [module.cert_manager]
}

module "nginx_ingress" {
  source             = "git::https://github.com/tenzin-io/terraform-tenzin-nginx-ingress-controller.git?ref=v0.0.3"
  nginx_service_type = "NodePort"
}

module "vault" {
  source                = "git::https://github.com/tenzin-io/terraform-tenzin-vault.git?ref=main"
  vault_fqdn            = "vault.tenzin.io"
  vault_backup_repo_url = "https://github.com/tenzin-io/vault-backup.git"
  depends_on            = [module.nginx_ingress]
}

module "homelab_services" {
  source = "git::https://github.com/tenzin-io/terraform-tenzin-nginx-ingress-external.git?ref=v0.1.0"
  external_services = {
    "homelab-vsphere" = {
      virtual_host = "vs.tenzin.io"
      address      = "100.70.3.84"
      protocol     = "HTTPS"
      port         = "443"
    }
    "homelab-artifactory" = {
      virtual_host      = "containers.tenzin.io"
      address           = "100.70.3.84"
      protocol          = "HTTPS"
      port              = "443"
      request_body_size = "24g"
    }
    "homelab-grafana-dev" = {
      virtual_host      = "grafana-dev.tenzin.io"
      address           = "100.79.243.143"
      protocol          = "HTTPS"
      port              = "443"
      request_body_size = "50m"
    }
  }
  redirect_services = {
    "aws" = {
      virtual_host = "aws.tenzin.io"
      redirect_url = "https://tenzin.awsapps.com/start#/"
    }
    "github" = {
      virtual_host = "github.tenzin.io"
      redirect_url = "https://github.com/tenzin-io/"
    }
    "tenzin-io" = {
      virtual_host = "tenzin.io"
      redirect_url = "https://github.com/tenzin-io/"
    }
  }
  depends_on = [module.nginx_ingress, module.cert_manager]
}
