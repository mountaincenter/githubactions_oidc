variable "app_name" {
}
variable "repository_names" {
  type = list(string)
  default = [
    "tf-app", "nginx"
  ]
}