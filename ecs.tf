# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "hosting-bot-cluster"
}

# ECR Repository
resource "aws_ecr_repository" "main" {
  name                 = "hosting-bot-repo"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}
