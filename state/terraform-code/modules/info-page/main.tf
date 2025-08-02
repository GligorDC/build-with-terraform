resource "github_repository" "this" {
  name        = "Testing"
  description = "Informational repo."
  visibility  = "public"
  auto_init   = true
  provisioner "local-exec" {
    command = var.run_provisioners ? "gh repo view ${self.name} --web" : "echo 'skip repo view'"
  }
}
resource "time_static" "this" {

}
resource "github_repository_file" "this" {
  repository          = github_repository.this.name
  branch              = "main"
  file                = "index.md"
  overwrite_on_create = true
  content = templatefile("${path.module}/templates/index.tfpl", {
    repos = local.repos
  })
}
data "terraform_remote_state" "repos" {
  backend = "remote"
  config = {
    organization = "Food_deivery",
    workspace = {
      name = "buildwithterraform"
    }
  }
}
locals {
  repos = { for k, v in data.terraform_remote_state.repos.infra.outputs.clone_urls["prod"].clone-url: k => v }
}