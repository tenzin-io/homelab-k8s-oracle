data "vault_generic_secret" "github" {
  path = "github/github_app"
}

data "vault_generic_secret" "cloudflare" {
  path = "github/cloudflare"
}
