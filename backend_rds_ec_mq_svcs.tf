resource "aws_db_subnet_group" "rds_private_subnet_group" {
  name       = "rds_private_subnet_group"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]

  tags = {
    Name = "rds_private_subnet_group"
  }
}

resource "aws_elasticache_subnet_group" "memcached-subnet-group" {
  name       = "memcached-subnet-group"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]
}

resource "aws_db_instance" "rds_mysql" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "5.6.34"
  instance_class         = "db.t2.micro"
  name                   = var.dbname
  username               = var.dbuser
  password               = var.dbpasswd
  parameter_group_name   = "default.mysql5.6"
  multi_az               = "true"
  publicly_accessible    = "false"
  skip_final_snapshot    = "true"
  db_subnet_group_name   = aws_db_subnet_group.rds_private_subnet_group.name
  vpc_security_group_ids = [aws_security_group.sg_for_backend_services.id]
}

resource "aws_elasticache_cluster" "memcached_cluster" {
  cluster_id                   = "memcached-cluster"
  engine                       = "memcached"
  node_type                    = "cache.t2.micro"
  num_cache_nodes              = 2
  parameter_group_name         = "default.memcached1.6"
  port                         = 11211
  security_group_ids           = [aws_security_group.sg_for_backend_services.id]
  subnet_group_name            = aws_elasticache_subnet_group.memcached-subnet-group.name
  az_mode                      = "cross-az"
  preferred_availability_zones = [var.AZ_1, var.AZ_2]
}

resource "aws_mq_broker" "active_mq" {
  broker_name        = "my-broker"
  engine_type        = "ActiveMQ"
  engine_version     = "5.15.0"
  host_instance_type = "mq.t2.micro"
  security_groups    = [aws_security_group.sg_for_backend_services.id]
  subnet_ids         = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
  deployment_mode    = "ACTIVE_STANDBY_MULTI_AZ"

  user {
    username = var.rmquser
    password = var.rmqpass
  }
}