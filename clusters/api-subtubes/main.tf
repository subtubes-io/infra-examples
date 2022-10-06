resource "aws_ecs_cluster" "subtubes_prod" {
  name     = "subtubes-prod"
  tags     = {}
  tags_all = {}

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}


resource "aws_ecs_cluster_capacity_providers" "api_subtubes" {
  cluster_name = aws_ecs_cluster.subtubes_prod.name

  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT",
  ]
}
