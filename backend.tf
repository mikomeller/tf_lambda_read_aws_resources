terraform {
  backend "s3" {
    bucket = "talent-academy-terraform-tfstates-787786425565"
    key    = "project/tf_lambda_read_aws_resources/terraform.tfstates"
    dynamodb_table = "terraform-lock"
    region = "eu-central-1"
    #lock = "dynamodb"
  }
}