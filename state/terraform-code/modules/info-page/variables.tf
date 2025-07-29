variable "repos" {
  description = "Repos"
  type        = map(any)
}
variable "run_provisioners" {
  description = ""
  type        = bool
  default     = true
}