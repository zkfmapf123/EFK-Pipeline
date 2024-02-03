resource "aws_security_group" "ec2-proxy-sg" {
  name   = "ec2-proxy-sg"
  vpc_id = module.network.vpc.vpc_id

  ingress = []

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-proxy-sg"
  }
}
