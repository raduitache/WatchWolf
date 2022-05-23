resource "aws_ecr_repository" "ecr_repo" {
  name                 = "${var.tags["Project"]}-${var.tags["Environment"]}-${var.tags["Creator"]}-${local.app_role}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(var.tags,
    {
      ApplicationRole = "${local.app_role}"
    }
  )
}
