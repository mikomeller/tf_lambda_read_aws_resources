resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a path.module in the filename. 

  # here it takes source_file from archive_file source below 
  filename      = "${path.module}/files/hello.zip"
  function_name = "hello_world"
  role          = aws_iam_role.iam_for_lambda.arn
  
  # call to the what function from the lambda console body is going to be execute, in this case
  handler       = "hello.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  # if the content here changed then the hash here changed as well
  source_code_hash = data.archive_file.lambda_deployment.output_base64sha256
#   filebase64sha256("lambda_function_payload.zip")

  runtime = "python3.9"
}

# creates archive out of the source
data "archive_file" "lambda_deployment" {
  type        = "zip"
  source_file = "${path.module}/src/hello.py"
  output_path = "${path.module}/files/hello.zip"
}