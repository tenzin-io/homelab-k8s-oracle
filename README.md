# README
A Terraform configuration repository to manage my Oracle cloud Kubernetes cluster.

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | 3.17.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | git::https://github.com/tenzin-io/terraform-tenzin-cert-manager.git | v0.0.2 |
| <a name="module_github_actions"></a> [github\_actions](#module\_github\_actions) | git::https://github.com/tenzin-io/terraform-tenzin-github-actions-runner-controller.git | v0.2.0 |
| <a name="module_homelab_services"></a> [homelab\_services](#module\_homelab\_services) | git::https://github.com/tenzin-io/terraform-tenzin-nginx-ingress-external.git | v0.1.0 |
| <a name="module_nginx_ingress"></a> [nginx\_ingress](#module\_nginx\_ingress) | git::https://github.com/tenzin-io/terraform-tenzin-nginx-ingress-controller.git | v0.0.3 |
| <a name="module_vault"></a> [vault](#module\_vault) | git::https://github.com/tenzin-io/terraform-tenzin-vault.git | v0.0.1 |

## Resources

| Name | Type |
|------|------|
| [vault_generic_secret.cloudflare](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.github](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
<!-- END_TF_DOCS -->
