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
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.tags["Project"]}-${var.tags["Environment"]}-${var.tags["Creator"]}-${local.app_role}"

  engine            = "mysql"
  engine_version    = "8.0.28"
  instance_class    = "db.t3.micro"
  allocated_storage = 10

  db_name  = "watchwolf"
  username = "admin"
  port     = "3306"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = "30"
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  multi_az = false
  subnet_ids             = var.database_subnets

  # DB parameter group
  create_db_parameter_group = false
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

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
}