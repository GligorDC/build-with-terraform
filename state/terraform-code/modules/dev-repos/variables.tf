# it is like declaring a type here used in terraform.tfvars
variable "repo_count" {
  type        = number
  description = "Number of repositories."
  default     = 1
  validation {
    # it will fail for 6 or 7
    condition     = var.repo_count < 5
    error_message = "it cannot be so low."
  }
}
variable "repo_max" {
  type        = number
  description = "Number of repositories."
  default     = 1
  validation {
    # it will fail for 6 or 7
    condition     = var.repo_max <= 5
    error_message = "it cannot be so low."
  }
}
variable "commingFrom" {
  type        = string
  description = "It is comming from the value file name"
  default     = "Variable is comming from variables.tf"
}
variable "env" {
  type        = string
  description = "Deployment environment."
  validation {
    condition     = contains(["dev", "prod"], var.env)
    error_message = "Env must be 'dev' or 'prod'"
  }
}

variable "repos" {
  type = map(map(string))
  validation {
    condition     = length(var.repos) <= var.repo_max
    error_message = "Too much infrastructure."
  }
}
variable "run_provisioners" {
  default = true
  type = bool
}