# One pilot number per primary agent. Purchased US local numbers with SMS
# and MMS capability; each inbound message is delivered to the healthy,
# cluster-owned bridge. Routing, sender allowlisting, and runtime secrets remain
# owned by kustomize-cluster.

variable "account_sid" {
  type        = string
  description = "Twilio account SID, supplied only from SOPS exec-env through TF_VAR_account_sid."
}

locals {
  inbound_messaging_url  = "https://sms.makeitwork.cloud/twilio/inbound"
  messaging_service_name = "opencode-sms-bridge"

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

# Owns the sender pool used by the bridge's optional Twilio Messaging Service
# delivery mode. The provider cannot manage A2P Brand/Campaign registration;
# associate this service and its senders with an approved campaign in Twilio
# before selecting it in GitOps.
resource "twilio_messaging_service" "opencode_sms_bridge" {
  friendly_name                 = local.messaging_service_name
  inbound_request_url           = local.inbound_messaging_url
  inbound_method                = "POST"
  use_inbound_webhook_on_number = true
  sticky_sender                 = true
}

# Keep the existing per-number inbound webhook as the authoritative inbound
# configuration while placing every bridge sender in the service's sender pool.
resource "twilio_messaging_phone_number" "agent" {
  for_each = twilio_phone_number.agent

  service_sid = twilio_messaging_service.opencode_sms_bridge.sid
  sid         = each.value.sid
}

output "agent_phone_numbers" {
  description = "Purchased pilot number for each primary agent."
  value       = { for name, number in twilio_phone_number.agent : name => number.phone_number }
}

output "opencode_sms_bridge_messaging_service_sid" {
  description = "Twilio Messaging Service SID for the bridge's non-secret GitOps configuration after the service is applied."
  value       = twilio_messaging_service.opencode_sms_bridge.sid
}
