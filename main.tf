resource "aws_ecr_repository" "main" {
  for_each = toset(var.repository_names)
  name     = each.value
  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
}