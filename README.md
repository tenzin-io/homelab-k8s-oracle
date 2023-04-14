# README
A Terraform configuration repository to manage my Oracle cloud Kubernetes cluster.

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.63.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | git::https://github.com/tenzin-io/terraform-tenzin-cert-manager.git | v0.0.2 |
| <a name="module_github_actions"></a> [github\_actions](#module\_github\_actions) | git::https://github.com/tenzin-io/terraform-tenzin-github-actions-runner-controller.git | v0.0.1 |

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.cloudflare_api_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.github_app_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.github_app_installation_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.github_app_private_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
<!-- END_TF_DOCS -->
