terraform {
  required_version = "> 1.3"

  # The permanent S3 backend is enabled only after its encrypted contract and
  # least-privilege CI access are reviewed in a follow-up pull request.
  backend "s3" {}

  required_providers {
    twilio = {
      source  = "RJPearson94/twilio"
      version = "0.27.1"
    }
  }
}

# No provider block is declared during bootstrap. The candidate provider is
# installed and syntax-validated without receiving credentials or managing
# Twilio resources.
