terraform {
  required_version = "> 1.3"

  required_providers {
    twilio = {
      source  = "RJPearson94/twilio"
      version = "0.27.1"
    }
  }
}

# The permanent S3 backend is intentionally omitted until its encrypted
# contract and least-privilege CI access are reviewed in a follow-up PR.
# The bootstrap Makefile initializes with -backend=false.

# No provider block is declared during bootstrap. The candidate provider is
# installed and syntax-validated without receiving credentials or managing
# Twilio resources.
