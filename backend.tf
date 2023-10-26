terraform {
  backend "s3" {
    bucket         = "terraform-state-file-ra"
    key            = "myapp/production/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform"
  }
}
