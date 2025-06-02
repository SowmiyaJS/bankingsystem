variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "ami_id" {
  type    = string
  default = "ami-0b092b4d48558a371"  
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
