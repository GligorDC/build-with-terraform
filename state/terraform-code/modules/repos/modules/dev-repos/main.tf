resource "random_id" "random" {
  byte_length = 2
  count       = var.repo_count
}
# resource "terraform_data" "repo_clone" {
#   for_each = var.envs
#   provisioner "local-exec" {
#     command = "gh repo view ${github_repository.test[each.key].name} --web"
#   }
#   provisioner "local-exec" {
#     command = "gh repo clone ${github_repository.test[each.key].name}"
#   }
#   depends_on = [github_repository_file.index, github_repository_file.readme]
# }

resource "github_repository" "test" {
  #not so used way of executing everything 2 times;
  # count       = var.repo_count
  # name        = "teting-repo-${random_id.random[count.index].dec}"
  for_each    = var.repos
  name        = "testing-repo-${var.env}-${each.key}"
  description = "${each.value.lang} Code for MIC"
  visibility  = var.env == "prod" ? "private" : "public"
  auto_init   = true
  #dinamyc magic word for having or nor having the statement
  dynamic "pages" {
    #foreach can be any number if it is [], it means nothing will be created.
    for_each = each.value.pages ? [1] : []
    content {
      source {
        branch = "main"
        path   = "/"
      }
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf ${self.name}"
  }
}

resource "github_repository_file" "readme" {
  for_each            = var.repos
  repository          = github_repository.test[each.key].name
  branch              = "main"
  file                = "README.md"
  content             = <<-EOT
                        # This is an auto message created with terraform, right? It was done by me.
                        It is crazyyy
                        EOT
  overwrite_on_create = true
  autocreate_branch   = true
  # lifecycle {
  #   ignore_changes = [
  #     content,
  #   ]
  # }
}

resource "github_repository_file" "main" {
  for_each   = var.repos
  repository = github_repository.test[each.key].name
  branch     = "main"
  file       = each.value.filename
  content = templatefile("${path.module}/templates/readme.tfpl", {
    env       = var.env,
    repo      = each.value.lang,
    normalVar = "normalVar"
  })
  overwrite_on_create = true
  autocreate_branch   = true
  #ignore th changes from external sources
  # lifecycle {
  #   ignore_changes = [
  #     content,
  #   ]
  # }
}
#it can be commented out leave for demo only
moved {
  from = github_repository_file.index
  to   = github_repository_file.main
}