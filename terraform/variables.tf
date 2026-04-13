variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Resource name prefix."
  type        = string
  default     = "travelmemory"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet."
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the two subnets."
  type        = string
  default     = "us-east-1a"
}

variable "allowed_ssh_cidr" {
  description = "Your public IP in CIDR form for SSH access to the web instance."
  type        = string
}

variable "key_pair_name" {
  description = "Existing EC2 key pair name for SSH."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for both servers."
  type        = string
  default     = "t3.micro"
}

variable "web_ami_id" {
  description = "Optional AMI override for the web instance. Leave empty to use the latest Ubuntu 22.04 AMI."
  type        = string
  default     = ""
}

variable "db_ami_id" {
  description = "Optional AMI override for the database instance. Leave empty to use the latest Ubuntu 22.04 AMI."
  type        = string
  default     = ""
}
