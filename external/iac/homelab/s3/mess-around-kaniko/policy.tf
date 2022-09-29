data "aws_iam_policy_document" "access_bucket_kaniko" {
  statement {
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      "arn:aws:s3:::mess-around-kaniko",
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
    resources = [
      "arn:aws:s3:::mess-around-kaniko/*",
    ]
  }
}

resource "aws_iam_policy" "bucket" {
  name   = "mess-around-kaniko-context"
  path   = "/"
  policy = data.aws_iam_policy_document.access_bucket_kaniko.json
}

resource "aws_iam_user" "user" {
  name = "mess-around-kaniko-context"
}

resource "aws_iam_user_policy_attachment" "aws_iam_policy" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.bucket.arn
}
