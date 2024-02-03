resource "aws_iam_role" "ec2-ssm-iam" {
  name = "ec2-ssm-iam"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

###################################################### policy 
data "aws_iam_policy" "ssm-role" {
  name = "AmazonEC2RoleforSSM"
}

resource "aws_iam_policy" "ec2-access-s3" {
  name        = "ec2-access-s3"
  path        = "/"
  description = "ec2-access-s3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AllowToListAllBucket"
        Action = [
          "s3:List*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "s3:Get*",
          "s3:Put*"
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.compose-files.arn}",
          "${aws_s3_bucket.compose-files.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  for_each = {
    for i, v in [data.aws_iam_policy.ssm-role, aws_iam_policy.ec2-access-s3] :
    i => v
  }

  role       = aws_iam_role.ec2-ssm-iam.name
  policy_arn = each.value.arn
}

resource "aws_iam_instance_profile" "ssm-ec2-profile" {
  name = aws_iam_role.ec2-ssm-iam.name
  role = aws_iam_role.ec2-ssm-iam.name
}
