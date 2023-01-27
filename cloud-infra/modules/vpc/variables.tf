variable "env" {
  description = "Environment name"
  default     = "dev"
  type        = string

}

variable "vpc_cidr" {
  description = "Cird range IP Addresses available in our vpc"
  type        = string

}
