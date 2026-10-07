variable "project_name" {
  description = "Base name used for Render resources."
  type        = string
  default     = "section-l-city-notes"
}

variable "vercel_project_name" {
  description = "Globally unique Vercel project name and default domain prefix."
  type        = string
  default     = "section-l-city-notes-ebriones14"
}

variable "github_repository" {
  description = "GitHub repository connected to Render and Vercel."
  type        = string
  default     = "ebriones14/section_l"
}

variable "production_branch" {
  description = "Branch deployed to production."
  type        = string
  default     = "main"
}

variable "render_region" {
  description = "Render region for the API and database."
  type        = string
  default     = "singapore"
}

variable "staff_config_pin" {
  description = "PIN used to unlock staff-only iPad configuration."
  type        = string
  sensitive   = true
  default     = "1026"
}
