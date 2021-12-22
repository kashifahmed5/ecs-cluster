variable "AWS_REGION" {
  default = "us-east-2"
}

variable "APP_NAME" {
  type        = string
  description = "Name Of the application."
  default     = "k-application"
}
variable "LOG_RETENTATION_IN_DAYS" {
  type        = number
  description = "Log Retentation for the ECS Log."
  default     = 3
}

variable "VPC_ID" {
  type        = string
  description = "VPC id for Loadbalancer."
  default     = "vpc-32ab755b"
}

variable "LB_SUBNETS" {
  type    = list(string)
  default = ["subnet-aa0717e0", "subnet-489e6233"]
}

variable "APPLICATION_SUBNETS" {
  type        = list(string)
  description = "Subnet for application loadbalancer"
  default     = ["subnet-aa0717e0", "subnet-489e6233"]
}
variable "CONTAINER_INSIGHTS" {
  type        = bool
  description = "Enable container insights."
  default     = true
}
variable "APPLICATION_IS_INTERNAL" {
  type        = bool
  default     = false
  description = "Define if application loadbalancer is internal or external."
}
