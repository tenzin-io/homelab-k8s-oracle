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
