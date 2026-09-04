terraform {
  required_version = "> 1.3"

  backend "s3" {}

  required_providers {
    twilio = {
      source  = "RJPearson94/twilio"
      version = "0.27.1"
    }
  }
}

# Authentication is supplied only through TWILIO_ACCOUNT_SID, TWILIO_API_KEY,
# and TWILIO_API_SECRET in SOPS exec-env. Do not add static credentials here.
provider "twilio" {}
