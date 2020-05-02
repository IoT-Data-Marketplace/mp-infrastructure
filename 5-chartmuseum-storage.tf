resource "aws_s3_bucket" "chartmuseum_storage_bucket" {
  bucket = format("iot-mp-chartmuseum-storage-bucket-%s", local.aws_region)
  acl    = "private"

  lifecycle_rule {
    id      = "keep-charts-six-months"
    enabled = true

    expiration {
      days = 180
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = false
  }

  tags = {
    Name = format("iot-mp-chartmuseum-storage-bucket-%s", local.aws_region)
  }
}

data "aws_iam_policy_document" "chartmuseum_storage_bucket_policy_access_policy_document" {
  statement {
    sid = "AllowCrossAccountReadWriteAccess"
    actions = [
      "s3:*"
    ]

    effect = "Allow"
    resources = [
      aws_s3_bucket.chartmuseum_storage_bucket.arn,
      format("%s/*", aws_s3_bucket.chartmuseum_storage_bucket.arn)
    ]
    principals {
      type = "AWS"
      identifiers = [
        data.aws_caller_identity.caller_identity.account_id
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "chartmuseum_storage_bucket_policy_access_policy" {
  policy = data.aws_iam_policy_document.chartmuseum_storage_bucket_policy_access_policy_document.json
  bucket = aws_s3_bucket.chartmuseum_storage_bucket.id
}