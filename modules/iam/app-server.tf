locals {
  name_prefix = var.prefix != "" ? "${var.prefix}-" : ""
}
resource "aws_iam_role" "ec2_role" {
  name = "${var.prefix}${var.ec2_role_name}"


  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com",
        },
        Action = "sts:AssumeRole",
      },
    ],
  })
}

resource "aws_iam_policy" "server_policy" {
  name = "${var.prefix}${var.iam_policy_name}"

  description = var.iam_policy_description

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = var.policy_actions,
        Effect   = "Allow",
        Resource = var.policy_resources,
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "ec2_role_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.server_policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.prefix}${var.instance_profile_name}"
  role = aws_iam_role.ec2_role.name
}
