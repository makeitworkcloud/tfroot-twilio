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
| [twilio_phone_number.agent](https://registry.terraform.io/providers/RJPearson94/twilio/0.27.1/docs/resources/phone_number) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_account_sid"></a> [account\_sid](#input\_account\_sid) | Twilio account SID, supplied only from SOPS exec-env through TF\_VAR\_account\_sid. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_agent_phone_numbers"></a> [agent\_phone\_numbers](#output\_agent\_phone\_numbers) | Purchased pilot number for each primary agent. |
<!-- END_TF_DOCS -->
