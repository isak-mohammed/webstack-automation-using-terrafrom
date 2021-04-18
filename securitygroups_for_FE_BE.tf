resource "aws_security_group" "beanstalk_alb_sg" {
  name        = "beanstalk_alb_sg"
  description = "Security Group for ALB provisioned by Elastic Beanstalk"
  vpc_id      = module.vpc.vpc_id

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "bastion_host_sg" {
  name        = "bastion_host_sg"
  description = "Security group for bastion host so that we can ssh into it to initialise RDS "
  vpc_id      = module.vpc.vpc_id

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow to ssh only from my ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.MYIP]
  }
}

resource "aws_security_group" "beanstalk_tomcat_ec2_sg" {
  name        = "beanstalk_tomcat_ec2_sg"
  description = "Security group for tomcat ec2 instances provisioned by Elastic Beanstalk"
  vpc_id      = module.vpc.vpc_id

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "Allow to ssh only from bastion host as our tomcat ec2 instances will be in private subnets"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_host_sg.id]
  }
}

resource "aws_security_group" "sg_for_backend_services" {
  name        = "sg_for_backend_services"
  description = "Security group for RDS, Elastic Cache, Amazon MQ"
  vpc_id      = module.vpc.vpc_id

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "Allow to frontend to interact with backedn services"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.beanstalk_tomcat_ec2_sg.id]
  }
}

resource "aws_security_group_rule" "allow_all_backend_services_to_interact_with_each_other" {
  description              = "Allow Amazon MQ, Elastic Cache, RDS to interact with each other"
  type                     = "ingress"
  from_port                = 0
  protocol                 = "tcp"
  to_port                  = 65535
  security_group_id        = aws_security_group.sg_for_backend_services.id
  source_security_group_id = aws_security_group.sg_for_backend_services.id
}