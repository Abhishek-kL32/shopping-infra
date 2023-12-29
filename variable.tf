variable "ami" {

  type        = string
  description = "ami id for ec2"
}

variable "project_name" {

  type        = string
  description = "name of the project"
}

variable "project_env" {

  type        = string
  description = "environment of the project"
}

variable "hosted_zone_name" {

  type        = string
  description = "main domain name"
}

variable "hostname" {

  type        = string
  description = "sub domain name for the website"
}

variable "instance_type" {

  type        = string
  description = "the instance type to be launched"
}
