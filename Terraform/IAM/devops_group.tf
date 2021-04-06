resource "aws_iam_group" "devops_group" {
  name = "devops"
}

resource "aws_iam_group_membership" "devops" {
  name = aws_iam_group.devops_group.name

  users = var.iam_user_list 

  group = aws_iam_group.devops_group.name
}
