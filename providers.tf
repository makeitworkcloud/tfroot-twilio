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

# No provider block is declared. The selected backend is independent of Twilio
# credentials and resource management; those remain separate follow-up gates.
