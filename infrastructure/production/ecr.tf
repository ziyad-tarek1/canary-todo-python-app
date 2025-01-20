resource "aws_ecr_repository" "ecr_repo" {
  name = "todo-app-img"
  image_scanning_configuration {
    scan_on_push = true
  }
}