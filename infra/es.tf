## Freetier는 cpu 옵션을 사용할수 없습니다.
module "default-public-ins" {
  source = "zkfmapf123/simpleEC2/lee"

  instance_name      = "es"
  instance_region    = "ap-northeast-2a"
  instance_subnet_id = lookup(module.network.vpc.was_subnets, "ap-northeast-2a")
  instance_sg_ids    = [aws_security_group.ec2-proxy-sg.id]

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
