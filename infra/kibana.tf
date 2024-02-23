resource "aws_security_group" "kibana-sg" {
  name   = "kibana-sg"
  vpc_id = module.network.vpc.vpc_id

  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kibana-sg"
  }
}

module "kibana" {
  source = "zkfmapf123/simpleEC2/lee"

  instance_name      = "kibana"
  instance_region    = "ap-northeast-2a"
  instance_subnet_id = lookup(module.network.vpc.was_subnets, "ap-northeast-2a")
  instance_sg_ids    = [aws_security_group.kibana-sg.id, aws_security_group.ec2-proxy-sg.id]

  instance_type = "t4g.small"
  instance_ip_attr = {
    is_public_ip  = false
    is_eip        = false
    is_private_ip = true
    private_ip    = "10.0.100.21"
  }

  instance_iam = aws_iam_instance_profile.ssm-ec2-profile.name

  instance_key_attr = {
    is_alloc_key_pair = false
    is_use_key_path   = false
    key_name          = ""
    key_path          = "~/.ssh/id_rsa.pub"
  }

  instance_tags = {
    "Monitoring" : true,
    "MadeBy" : "terraform",
    "Name" : "kibana"
  }
}
