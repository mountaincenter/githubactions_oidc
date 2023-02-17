module "ecr" {
  source   = "./ecr"
  app_name = var.app_name
}