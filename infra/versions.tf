terraform {
  required_version = ">= 1.11.0"

  required_providers {
    render = {
      source  = "render-oss/render"
      version = "~> 1.9"
    }

    vercel = {
      source  = "vercel/vercel"
      version = "~> 5.17"
    }
  }
}

provider "render" {
  wait_for_deploy_completion = true
}

provider "vercel" {}
