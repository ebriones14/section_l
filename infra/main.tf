locals {
  frontend_origin = "https://${var.vercel_project_name}.vercel.app"
  repository_url  = "https://github.com/${var.github_repository}"
}

resource "render_postgres" "database" {
  name          = "${var.project_name}-db"
  plan          = "free"
  region        = var.render_region
  version       = "16"
  database_name = "section_l_production"
  database_user = "section_l"
}

resource "render_web_service" "api" {
  name              = "${var.project_name}-api"
  plan              = "free"
  region            = var.render_region
  health_check_path = "/up"

  runtime_source = {
    docker = {
      repo_url        = local.repository_url
      branch          = var.production_branch
      auto_deploy     = true
      context         = "backend"
      dockerfile_path = "backend/Dockerfile"
    }
  }

  env_vars = {
    DATABASE_URL = {
      value = render_postgres.database.connection_info.internal_connection_string
    }
    FRONTEND_ORIGIN = {
      value = local.frontend_origin
    }
    RAILS_ENV = {
      value = "production"
    }
    RAILS_SEED_DATABASE = {
      value = "true"
    }
    SECRET_KEY_BASE = {
      generate_value = true
    }
    STAFF_CONFIG_PIN = {
      value = var.staff_config_pin
    }
  }
}

resource "vercel_project" "frontend" {
  name             = var.vercel_project_name
  framework        = "vite"
  root_directory   = "frontend"
  install_command  = "npm ci"
  build_command    = "npm run build"
  output_directory = "dist"

  git_repository = {
    type              = "github"
    repo              = var.github_repository
    production_branch = var.production_branch
  }
}

resource "vercel_project_environment_variable" "api_url" {
  project_id = vercel_project.frontend.id
  key        = "VITE_API_URL"
  value      = render_web_service.api.url
  target     = ["production", "preview"]
  sensitive  = false
}

resource "vercel_deployment" "frontend" {
  project_id = vercel_project.frontend.id
  ref        = var.production_branch
  production = true

  environment = {
    VITE_API_URL = render_web_service.api.url
  }

  project_settings = {
    framework        = "vite"
    root_directory   = "frontend"
    install_command  = "npm ci"
    build_command    = "npm run build"
    output_directory = "dist"
  }

  depends_on = [vercel_project_environment_variable.api_url]
}
