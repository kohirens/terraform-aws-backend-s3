data "aws_caller_identity" "current" {}

locals {
  account_id     = data.aws_caller_identity.current.account_id
  name           = "terraform-backend"
  full_name      = var.label != "" ? "${var.label}-${local.account_id}-${local.name}" : "${local.account_id}-${local.name}"
  dynamodb_count = var.use_s3_locking ? 0 : 1

  tags = merge(
    var.label != "" ? { module = local.name, label = var.label } : { module = local.name }
  )
}

resource "aws_s3_bucket_policy" "backend_storage" {
  bucket = aws_s3_bucket.backend_storage.bucket

  policy = templatefile("${path.module}/backend-storage-policy.tftpl.json", {
    account_id = local.account_id
    bucket_arn = aws_s3_bucket.backend_storage.arn
  })
}

resource "aws_s3_bucket" "backend_storage" {
  bucket        = local.full_name
  tags          = local.tags
  force_destroy = false # force the user to manually destroy all objects.
}

resource "aws_s3_bucket_logging" "backend_storage" {
  bucket        = aws_s3_bucket.backend_storage.bucket
  target_bucket = aws_s3_bucket.backend_storage_logs.bucket
  target_prefix = local.name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backend_storage" {
  bucket = aws_s3_bucket.backend_storage.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_versioning" "backend_storage" {
  bucket = aws_s3_bucket.backend_storage.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "backend_storage" {
  bucket                  = aws_s3_bucket.backend_storage.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Begin access log bucket
resource "aws_s3_bucket" "backend_storage_logs" {
  bucket        = "${local.full_name}-logs"
  force_destroy = false
  tags          = local.tags
}

resource "aws_s3_bucket_versioning" "backend_storage_logs" {
  bucket = aws_s3_bucket.backend_storage_logs.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "backend_storage_logs" {
  bucket = aws_s3_bucket.backend_storage_logs.bucket

  rule {
    id     = "${aws_s3_bucket.backend_storage_logs.bucket}-rule"
    status = "Enabled"

    filter {
      and {
        prefix = local.name
        tags = {
          rule      = "${aws_s3_bucket.backend_storage_logs.bucket}-rule"
          autoclean = "true"
        }
      }
    }

    transition {
      days          = 45
      storage_class = "STANDARD_IA" # or "ONEZONE_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 183
    }
  }
}

resource "aws_s3_bucket_public_access_block" "backend_storage_logs" {
  bucket                  = aws_s3_bucket.backend_storage_logs.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "backend_lock_table" {
  # If made, the the backend storage will use this for state locking.
  depends_on   = [aws_s3_bucket.backend_storage]
  count        = local.dynamodb_count
  name         = "${local.full_name}-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_dynamodb_resource_policy" "backend_lock_table" {
  count        = local.dynamodb_count
  resource_arn = aws_dynamodb_table.backend_lock_table[0].arn

  policy = templatefile("${path.module}/lock-table-policy.tftpl.json", {
    account_id = local.account_id
    table_arn  = aws_dynamodb_table.backend_lock_table[0].arn
  })
}
