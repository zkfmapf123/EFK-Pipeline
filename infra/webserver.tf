resource "aws_security_group" "webserver-sg" {
  name   = "webserver-sg"
  vpc_id = module.network.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-webserver-sg"
  }
}

module "webserver-instnace" {
  source = "zkfmapf123/simpleEC2/lee"

  instance_name      = "es"
  instance_region    = "ap-northeast-2a"
  instance_subnet_id = lookup(module.network.vpc.webserver_subnets, "ap-northeast-2a")
  instance_sg_ids    = [aws_security_group.webserver-sg.id, aws_security_group.ec2-proxy-sg.id]

  instance_type = "t2.micro"
  instance_ami  = "ami-09296805c0d8f0af5"

  instance_ip_attr = {
    is_public_ip  = true
    is_eip        = false
    is_private_ip = false
    private_ip    = ""
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
    "Name" : "WEBSERVER-INSTANCE"
  }
}
