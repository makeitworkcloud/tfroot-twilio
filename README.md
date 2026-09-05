<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 1.3 |
| <a name="requirement_twilio"></a> [twilio](#requirement\_twilio) | 0.27.1 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_twilio"></a> [twilio](#provider\_twilio) | 0.27.1 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [twilio_messaging_phone_number.agent](https://registry.terraform.io/providers/RJPearson94/twilio/0.27.1/docs/resources/messaging_phone_number) | resource |
| [twilio_messaging_service.opencode_sms_bridge](https://registry.terraform.io/providers/RJPearson94/twilio/0.27.1/docs/resources/messaging_service) | resource |
| [twilio_phone_number.agent](https://registry.terraform.io/providers/RJPearson94/twilio/0.27.1/docs/resources/phone_number) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_account_sid"></a> [account\_sid](#input\_account\_sid) | Twilio account SID, supplied only from SOPS exec-env through TF\_VAR\_account\_sid. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_agent_phone_numbers"></a> [agent\_phone\_numbers](#output\_agent\_phone\_numbers) | Purchased pilot number for each primary agent. |
| <a name="output_opencode_sms_bridge_messaging_service_sid"></a> [opencode\_sms\_bridge\_messaging\_service\_sid](#output\_opencode\_sms\_bridge\_messaging\_service\_sid) | Twilio Messaging Service SID for the bridge's non-secret GitOps configuration after the service is applied. |
<!-- END_TF_DOCS -->
