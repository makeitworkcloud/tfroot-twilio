# One pilot number per primary agent. Purchased US local numbers with SMS
# and MMS capability; each inbound message is delivered to the healthy,
# cluster-owned bridge. Routing, sender allowlisting, and runtime secrets remain
# owned by kustomize-cluster.

variable "account_sid" {
  type        = string
  description = "Twilio account SID, supplied only from SOPS exec-env through TF_VAR_account_sid."
}

locals {
  inbound_messaging_url = "https://sms.makeitwork.cloud/twilio/inbound"

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

  messaging {
    url    = local.inbound_messaging_url
    method = "POST"
  }
}

output "agent_phone_numbers" {
  description = "Purchased pilot number for each primary agent."
  value       = { for name, number in twilio_phone_number.agent : name => number.phone_number }
}
