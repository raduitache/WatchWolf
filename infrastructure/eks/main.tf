
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

resource "aws_security_group" "worker_group" {
  name_prefix = "eks-worker-group-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      var.cidr_range,
    ]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 17.0"

  cluster_name      = "${var.tags["Project"]}-${var.tags["Environment"]}-${var.tags["Creator"]}-${local.app_role}"
  cluster_version   = "1.22"
  vpc_id            = var.vpc_id
  subnets           = var.private_subnets
  workers_role_name = "${var.tags["Project"]}-${var.tags["Environment"]}-${var.tags["Creator"]}-${local.worker_name}"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false

  worker_groups = [
    {
      name                          = "eks-worker-group"
      instance_type                 = "t2.medium"
      additional_security_group_ids = [aws_security_group.worker_group.id]
      asg_desired_capacity          = 1
    }
  ]

  tags = merge(var.tags,
    {
      ApplicationRole = "${local.app_role}"
    }
  )
}
