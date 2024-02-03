resource "aws_security_group" "es-sg" {
  name   = "es-sg"
  vpc_id = module.network.vpc.vpc_id

  ingress {
    from_port       = 9200
    to_port         = 9200
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2-proxy-sg.id]
  }

  ingress {
    from_port       = 5601
    to_port         = 5601
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2-proxy-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-es-sg"
  }
}

## Docker, Docker-compose 설치 
## compose-files/es.docker-compose 
module "default-public-ins" {
  source = "zkfmapf123/simpleEC2/lee"

  instance_name      = "es"
  instance_region    = "ap-northeast-2a"
  instance_subnet_id = lookup(module.network.vpc.was_subnets, "ap-northeast-2a")
  instance_sg_ids    = [aws_security_group.ec2-proxy-sg.id, aws_security_group.es-sg.id]

  instance_type = "t4g.medium"
  instance_ip_attr = {
    is_public_ip  = false
    is_eip        = false
    is_private_ip = true
    private_ip    = "10.0.100.10"
  }

  instance_iam = aws_iam_instance_profile.ssm-ec2-profile.name

  #   instance_root_device = {
  #       size =20
  #       type = "gp3"
  #   }

  instance_key_attr = {
    is_alloc_key_pair = false
    is_use_key_path   = false
    key_name          = ""
    key_path          = "~/.ssh/id_rsa.pub"
  }

  instance_tags = {
    "Monitoring" : true,
    "MadeBy" : "terraform",
    "Name" : "ES-INSTANCE"
  }
}
