########### subnet group ###########
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "handson-rds-subnet-group"
  description = "DB subnet group for Aurora."
  subnet_ids = [
    module.subnet_private_db_1a.subnet_id,
    module.subnet_private_db_1c.subnet_id
  ]

  tags = {
    Name = "handson-rds-subnet-group"
  }

  depends_on = [
    module.subnet_private_db_1a,
    module.subnet_private_db_1c
  ]
}

########### IAM Role for Aurora Instance ###########
data "aws_iam_policy" "AmazonRDSEnhancedMonitoringRole" {
    arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

module "rds_monitoring_role" {
  source = "../../modules/iam_role"
  name = "rdsMonitoringRole"
  identifier = "monitoring.rds.amazonaws.com"
  policy = data.aws_iam_policy.AmazonRDSEnhancedMonitoringRole.policy
}

########### Aurora ###########
resource "aws_rds_cluster" "db_cluster" {
  cluster_identifier      = "handson-db"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.10.2"
  availability_zones      = ["ap-northeast-1a", "ap-northeast-1c"]
  database_name           = "handsonapp"
  master_username         = "admin"
  master_password         = "password"
  port                 = 3306
  backup_retention_period = 1
  enabled_cloudwatch_logs_exports = [
    "audit",
    "error",
    "slowquery"
  ]
  preferred_backup_window = "07:00-09:00"
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [
    module.sg_db.sg_id
  ]
  preferred_maintenance_window = "Sat:17:00-Sat:17:30"
  skip_final_snapshot  = true
  storage_encrypted = true

  lifecycle {
    ignore_changes = [
      availability_zones
    ]
  }
  depends_on = [
    aws_db_subnet_group.rds_subnet_group
  ]
}

resource "aws_rds_cluster_instance" "db" {
  count              = 2
  identifier         = "handson-db-${count.index}"
  cluster_identifier = aws_rds_cluster.db_cluster.id
  instance_class     = "db.t3.small"
  engine             = aws_rds_cluster.db_cluster.engine
  engine_version     = aws_rds_cluster.db_cluster.engine_version
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  publicly_accessible = false
  auto_minor_version_upgrade = true
  monitoring_role_arn = module.rds_monitoring_role.iam_role_arn
  monitoring_interval = 60
  db_parameter_group_name = "default.aurora-mysql5.7"
  copy_tags_to_snapshot = true
}