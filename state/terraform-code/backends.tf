# terraform {
#   backend "local" {
#     path = "../state/terraform.tfstate"
#   }
# }
terraform { 
  cloud { 
    
    organization = "Food_delivery" 

    workspaces { 
      name = "FD" 
    } 
  } 
}