<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | This is ingress rules for the security group. | <pre>map(<br>      object(<br>          {<br>              port = number<br>              cidr_blocks = list(string)<br>              security_groups = list(string)<br>          }<br>      )<br>  )</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | This is a name of the security group. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | This is a VPC ID for the security group. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sg_id"></a> [sg\_id](#output\_sg\_id) | This is a resource id of the security group. |
| <a name="output_sg_name"></a> [sg\_name](#output\_sg\_name) | This is a name id of the security group. |
<!-- END_TF_DOCS -->