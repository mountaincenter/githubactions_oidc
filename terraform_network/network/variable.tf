variable "app_name" {}

variable "vpc_cidr" {
  default = "10.0.0.0/21"
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "azs" {
  type    = list(string)
  default = ["1a", "1c"]
}