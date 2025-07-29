resource "local_file" "repos" {
  #for demo purpose we are transforming the values from local to a json used further to get the variables from file.
  content = jsonencode(local.repos)
  filename = "${path.module}/repos.json"
}

module "repos" {
  source     = "./modules/dev-repos"
  for_each   = var.environments
  repo_count = 2
  repo_max   = 5
  env        = each.key
  repos      = jsondecode(file("repos.json"))
}

module "deploy-key" {
  for_each  = var.deploy_key ? toset(flatten([for k, v in module.repos : keys(v.clone-urls) if k == "dev"])) : []
  source    = "./modules/deploy-key"
  repo_name = "testing-repo-dev-backend"
  depends_on = [
    module.repos
  ]
}

module "info-page" {
  source           = "./modules/info-page"
  repos            = { for k, v in module.repos["prod"].clone-urls : k => v }
  run_provisioners = false
}


output "repos-information" {
  value = { for k, v in module.repos : k => v }
}