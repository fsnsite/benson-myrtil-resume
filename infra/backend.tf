terraform {
  backend "s3" {
    region         = "us-east-1"
    bucket         = "terraform-state-fsn-702175707031"
    key            = "benson-myrtil-resume-prod/terraform.tfstate"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
