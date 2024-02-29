variable "email_address" {
  description = "The email address the contact me forms will be sent to."
  type        = string
}

variable "lambda_runtime" {
  description = "The runtime for the lambda function."
  type        = string
  default     = "nodejs16.x"
}

variable "prefix" {
  description = "Three letter project prefix."
  type        = string

  validation {
    condition     = length(var.prefix) == 3
    error_message = "The prefix value must be 3 characters long."
  }
}

variable "region" {
  description = "The AWS region."
  type        = string
  default     = "eu-west-2"
}

variable "stage_name" {
  description = "Stage name for the contact me form API gateway."
  type        = string
  default     = "02"
}
