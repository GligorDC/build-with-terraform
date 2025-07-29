terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.6.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.1"
    }
  }
}

provider "github" {

}

provider "time" {
  # Configuration options
}