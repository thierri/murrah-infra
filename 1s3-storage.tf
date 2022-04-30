
resource "random_pet" "lambda_bucket_name" {
  prefix = "murrah-lambda"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
  force_destroy = true
}

data "archive_file" "lambda_hello_world" {

  type = "zip"

  source_dir  = "${path.module}/js"
  output_path = "${path.module}/js.zip"
}

resource "aws_s3_object" "lambda_hello_world" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "js.zip"
  source = data.archive_file.lambda_hello_world.output_path

  etag = filemd5(data.archive_file.lambda_hello_world.output_path)
}
