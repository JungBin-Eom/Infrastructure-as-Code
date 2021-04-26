resource "aws_iam_user" "tom" {
  name = "tom"
}

resource "aws_iam_user_policy" "ricky_devops" {
  name = "super-admin"
  user = aws_iam_user.tom.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

