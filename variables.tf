# VPC
variable "vpc_cidr" {
  type = string
}

variable "public_1_subnet_cidr" {
  type = string
}

variable "public_2_subnet_cidr" {
  type = string
}

variable "private_1_subnet_cidr" {
  type = string
}

variable "private_2_subnet_cidr" {
  type = string
}

variable "az_1" {
    type = string
}

variable "az_2" {
    type = string
}

# EC2
variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

# variable "public_subnet_1" {
#   type = string
# }

# variable "public_subnet_2" {
#   type = string
# }

# variable "private_subnet_1" {
#   type = string
# }

# variable "private_subnet_2" {
#   type = string
# }

#sg
variable "my_ip" {
  type = string
}

variable "domain_name" {
  type        = string
}

variable "zone_name" {
  type        = string
}

variable "db_username" {
  type        = string
}

variable "db_password" {
  type        = string
}

variable "db_name" {
  type        = string
}

variable "record_name" {
  type        = string
}
