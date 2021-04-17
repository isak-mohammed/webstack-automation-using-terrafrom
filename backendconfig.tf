terraform {
  backend "s3" {
    bucket = "tf-state-bucket-isak"
    key    = "terraform/backend.tfstate"
    region = "eu-west-2"
  }
}