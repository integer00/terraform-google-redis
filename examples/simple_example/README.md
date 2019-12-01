# Simple Example

This example illustrates how to use the `redis` module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project\_id | The ID of the project in which to provision resources. | string | n/a | yes |
| redis\_instance\_metadata | Redis instance metadata | map(string) | `<map>` | no |
| redis\_listen\_port | Redis listen port | string | `"6969"` | no |

## Outputs

| Name | Description |
|------|-------------|
| project\_id | The ID of the project in which resources are provisioned. |
| redis\_firewall\_name | Redis vm firewall name |
| redis\_instance\_internal\_ip | Redis vm internal ip |
| redis\_instance\_name | Redis vm name |
| redis\_instance\_public\_ip | Redis vm public ip |
| redis\_instance\_zone | Redis default zone |
| redis\_port | Redis listen port |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
