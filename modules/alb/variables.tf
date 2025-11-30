variable "alb_sg_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "ec2_1_id" {
  type = string
}

variable "ec2_2_id" {
  type = string
}

variable "certificate_arn" {
  type = string
}
