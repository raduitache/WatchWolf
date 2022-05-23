resource "aws_security_group" "rds_sg" {
  name_prefix = "${var.tags["Project"]}-${var.tags["Environment"]}-${var.tags["Creator"]}-${local.app_role}-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"

    cidr_blocks = [
      var.cidr_range,
    ]
  }

  tags = merge(var.tags,
    {
      ApplicationRole = "rds-sg"
    }
  )
}

data "aws_subnet" "private_subnet1" {
  id = "subnet-018e87cc5e124c9fe"
}

data "aws_subnet" "private_subnet2" {
  id = "subnet-0cdf9046db0d2dded"
}

data "aws_subnet" "private_subnet3" {
  id = "subnet-0dea40ef3b671559a"
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.tags["Project"]}-${var.tags["Environment"]}-${var.tags["Creator"]}-${local.app_role}-subnet-group"
  subnet_ids = [data.aws_subnet.private_subnet1.id, data.aws_subnet.private_subnet2.id, data.aws_subnet.private_subnet3.id]

  tags = merge(var.tags,
    {
      ApplicationRole = "rds-subnet-group"
    }
  )
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier           = "${var.tags["Project"]}-${var.tags["Environment"]}-${var.tags["Creator"]}-${local.app_role}"
  engine               = "mysql"
  engine_version       = "8.0.28"
  instance_class       = "db.t3.micro"
  major_engine_version = "8.0"
  allocated_storage    = 10

  db_name  = "watchwolf"
  username = "admin"
  port     = "3306"

  iam_database_authentication_enabled = true

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = "30"
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = true

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  multi_az               = false
  subnet_ids             = var.private_subnets

  # DB parameter group
  create_db_parameter_group = false
  family                    = "mysql8.0"

  # Database Deletion Protection
  deletion_protection = true

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]

  tags = merge(var.tags,
    {
      ApplicationRole = "${local.app_role}"
    }
  )
}