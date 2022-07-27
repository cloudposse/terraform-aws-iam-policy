terraform {
  required_version = ">= 1.0"

  required_providers {
    # Update these to reflect the actual requirements of your module
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0"
    }
  }
}
