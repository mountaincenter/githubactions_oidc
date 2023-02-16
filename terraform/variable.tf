variable "app_name" {
  default = "tf-oidc"
}
variable "repository_names" {
  type = list(string)
  default = [
    "tf-app", "nginx"
  ]
}