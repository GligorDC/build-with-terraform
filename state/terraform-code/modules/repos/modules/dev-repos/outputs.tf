output "clone-name" {
  value = {
    for k, repo in github_repository.test : k => repo.name
  }
  description = "Repository names"
  sensitive   = false
  #don't display in console, but still display in state
}

output "clone-urls" {
  value = {
    for repo in github_repository.test : repo.name => repo.http_clone_url
  }
  description = "Repository names"
  sensitive   = false
  #don't display in console, but still display in state
}

output "clone-urls-sensitive" {
  value = {
    for repo in github_repository.test : repo.name => {
      repo-clone = repo.http_clone_url,
      pages-url  = try(repo.pages[0].html_url, "No file supported")
    }
  }
  description = "Repository names"
  sensitive   = false
  #sensitive   = true
  #don't display in console, but still display in state
}

output "display-terraform-output" {
  value       = var.commingFrom
  description = "Repository names"
  #don't display in console, but still display in state
}