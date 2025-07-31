terraform {
  backend "remote" {
    organization = "Food_delivery"

    workspaces {
      name = "Ci-Cd-testing"
    }
  }
}
