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
  source                     = "git::https://github.com/tenzin-io/terraform-tenzin-github-actions-runner-controller.git?ref=v0.1.0"
  github_org_name            = "tenzin-io"
  github_app_id              = chomp(data.aws_ssm_parameter.github_app_id.value)
  github_app_installation_id = chomp(data.aws_ssm_parameter.github_app_installation_id.value)
  github_app_private_key     = data.aws_ssm_parameter.github_app_private_key.value
  github_runner_labels       = ["oracle"]
  depends_on                 = [module.cert_manager]
}

module "nginx_ingress" {
  source             = "git::https://github.com/tenzin-io/terraform-tenzin-nginx-ingress-controller.git?ref=v0.0.3"
  nginx_service_type = "NodePort"
}

module "vault" {
  source                = "git::https://github.com/tenzin-io/terraform-tenzin-vault.git?ref=v0.0.1"
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
