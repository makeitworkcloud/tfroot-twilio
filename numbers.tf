# One pilot number per primary agent. Purchased US local numbers with SMS
# and MMS capability; no inbound webhook is configured here. The messaging
# webhook is added only after the kustomize-cluster bridge is healthy.

variable "account_sid" {
  type        = string
  description = "Twilio account SID, supplied only from SOPS exec-env through TF_VAR_account_sid."
}

locals {
  agent_numbers = {
    lawnmowerman = "opencode-sms lawnmowerman"
    grillmaster  = "opencode-sms grillmaster"
    homesteader  = "opencode-sms homesteader"
    homerepair   = "opencode-sms homerepair"
  }
}

resource "twilio_phone_number" "agent" {
  for_each = local.agent_numbers

  account_sid   = var.account_sid
  friendly_name = each.value

  search_criteria {
    iso_country = "US"
    type        = "local"

    capabilities {
      sms_enabled = true
      mms_enabled = true
    }
  }
}

output "agent_phone_numbers" {
  description = "Purchased pilot number for each primary agent."
  value       = { for name, number in twilio_phone_number.agent : name => number.phone_number }
}
