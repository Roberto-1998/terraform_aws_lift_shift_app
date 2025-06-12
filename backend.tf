terraform {
backend "s3" {
bucket = "terraformstate9808"
key = "terraform/backend"
region = "us-east-1"
}
}