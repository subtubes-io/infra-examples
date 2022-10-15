# terraform import aws_db_instance.subtubes_api_prod subtubes-api-prod
# terraform state show aws_db_instance.subtubes_api_prod 

resource "aws_db_instance" "subtubes_api_prod" {
  allocated_storage          = 400
  auto_minor_version_upgrade = true
  availability_zone          = "us-west-2b"
  backup_retention_period    = 7
  backup_window              = "12:05-12:35"
  ca_cert_identifier         = "rds-ca-2019"
  copy_tags_to_snapshot      = true
  customer_owned_ip_enabled  = false
  db_name                    = "subtubes_api"
  db_subnet_group_name       = "default-vpc-0ce5095cbee1e5862"
  delete_automated_backups   = true
  deletion_protection        = true
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
  multi_az                              = true
  network_type                          = "IPV4"
  option_group_name                     = "default:postgres-13"
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
  # lifecycle {
  #   ignore_changes = [latest_restorable_time]
  # }
  timeouts {}
}

# terraform import aws_security_group.subtubes_api_prod sg-0bbbd41d2a9825679
# terraform state show aws_security_group.subtubes_api_prod
resource "aws_security_group" "subtubes_api_prod" {

  description = "Created by RDS management console"
  name        = "subtubes-api-rds"
  tags        = {}
  tags_all    = {}
  vpc_id      = data.terraform_remote_state.vpc.outputs.prod_main_vpc_id

  timeouts {}

}

# terraform import aws_security_group_rule.base_egress sg-0bbbd41d2a9825679_egress_all_0_0_0.0.0.0/0
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


# terraform import aws_security_group_rule.base_ingress sg-0bbbd41d2a9825679_ingress_tcp_5432_5432_67.161.63.179/32
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
