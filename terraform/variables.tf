locals {
  labels = {
    "status" = ""
    "criticality" = ""
    "solution" = var.solution
  }
}

variable "project_id" {
  description = "The Project ID"
  type        = string
}

variable "project_number" {
  description = "The Project number used to identify resources"
  type        = string
}

variable "location" {
  description = "The location for the resources"
  type        = string
  default     = "US"
  
}

variable "region" {
  description = "The region to operate under"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The zone within the region"
  type        = string
  default     = "us-central1-c"
}
variable "email" {
  description = "Developer's e-mail"
  type        = string
}
variable "env" {
  description = "Environment"
  type        = string
}

variable "solution" {
  description = "Solution's Title"
  type        = string
}

variable "git-repository" {
  description = "Git URL"
  type        = string
}

variable "branch" {
  description = "Defult branch for Dataform"
  type        = string
}

variable "git_token" {
  description = "Token to access the git repository"
  type        = string
}