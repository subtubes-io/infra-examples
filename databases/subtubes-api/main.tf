
data "aws_ssm_parameter" "subtubes_api_prod_rds_password" {
  name            = "prod.subtubes_api.rds.password"
  with_decryption = true
}
resource "aws_db_instance" "subtubes_api_prod" {
  allocated_storage          = 400
  auto_minor_version_upgrade = true
  backup_retention_period    = 7
  backup_window              = "12:05-12:35"
  ca_cert_identifier         = "rds-ca-2019"
  copy_tags_to_snapshot      = true
  customer_owned_ip_enabled  = false
  db_name                    = "subtubes_api"
  db_subnet_group_name       = aws_db_subnet_group.subtubes_api_prod.name
  delete_automated_backups   = true
  deletion_protection        = false
  enabled_cloudwatch_logs_exports = [
    "postgresql",
    "upgrade",
  ]
  engine                                = "postgres"
  engine_version                        = "13.7"
  iam_database_authentication_enabled   = true
  identifier                            = "subtubes-api-prod"
  instance_class                        = "db.m5.large"
  iops                                  = 3000
  kms_key_id                            = "arn:aws:kms:us-west-2:568949616117:key/03fe28d6-d3de-4646-8385-fafa17830fc4"
  license_model                         = "postgresql-license"
  maintenance_window                    = "sun:00:00-sun:00:30"
  max_allocated_storage                 = 1000
  monitoring_interval                   = 60
  monitoring_role_arn                   = aws_iam_role.rds_monitoring_role.arn
  multi_az                              = true
  network_type                          = "IPV4"
  option_group_name                     = "default:postgres-13"
  password                              = data.aws_ssm_parameter.subtubes_api_prod_rds_password.value
  parameter_group_name                  = "default.postgres13"
  performance_insights_enabled          = true
  performance_insights_kms_key_id       = "arn:aws:kms:us-west-2:568949616117:key/03fe28d6-d3de-4646-8385-fafa17830fc4"
  performance_insights_retention_period = 7
  port                                  = 5432
  publicly_accessible                   = false
  skip_final_snapshot                   = true
  storage_encrypted                     = true
  storage_type                          = "io1"
  tags                                  = {}
  tags_all                              = {}
  username                              = "postgres"
  vpc_security_group_ids = [
    aws_security_group.subtubes_api_prod.id
  ]
  timeouts {}

}

resource "aws_security_group" "subtubes_api_prod" {

  name     = "subtubes-api-rds"
  tags     = {}
  tags_all = {}
  vpc_id   = data.terraform_remote_state.vpc.outputs.prod_main_vpc_id

  timeouts {}

}

resource "aws_security_group_rule" "base_egress" {
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.subtubes_api_prod.id
  to_port           = 0
  type              = "egress"

  timeouts {}

}

resource "aws_security_group_rule" "base_ingress" {
  cidr_blocks = [
    "67.161.63.179/32",
  ]
  from_port         = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.subtubes_api_prod.id
  to_port           = 5432
  type              = "ingress"

  timeouts {}
}

resource "aws_db_subnet_group" "subtubes_api_prod" {
  #description = "Created from the RDS Management Console"
  name       = "subtubes-api-prod"
  subnet_ids = data.terraform_remote_state.vpc.outputs.prod_main_private_subnets_ids
  tags       = {}
  tags_all   = {}
}



resource "aws_iam_role" "rds_monitoring_role" {

  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "monitoring.rds.amazonaws.com"
          }
          Sid = ""
        },
      ]
      Version = "2012-10-17"
    }
  )
  force_detach_policies = false
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole",
  ]
  max_session_duration = 3600
  name                 = "rds-monitoring-role"
  path                 = "/"
  tags                 = {}
  tags_all             = {}
}
