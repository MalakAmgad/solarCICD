variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the EC2 Key Pair"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "solarCICD"
}
