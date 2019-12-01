# terraform-google-redis

This module was generated from [terraform-google-module-template](https://github.com/terraform-google-modules/terraform-google-module-template/), which by default generates a module that simply creates a GCS bucket. As the module develops, this README should be updated.

The resources/services/activations/deletions that this module will create/trigger are:

- Create a GCS bucket with the provided name

## Usage

Basic usage of this module is as follows:

```hcl
module "redis" {
  source  = "terraform-google-modules/redis/google"
  version = "~> 0.1"

  project_id  = "<PROJECT ID>"
}
```

Functional examples are included in the
[examples](./examples/) directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project\_id | The project ID to deploy to | string | n/a | yes |
| redis\_instance\_disk\_size | Redis disk size in GB | string | `"10"` | no |
| redis\_instance\_disk\_type | Redis disk type | string | `"pd-standard"` | no |
| redis\_instance\_image\_type | Redis image type | string | `"centos-7"` | no |
| redis\_instance\_machine\_type | Redis machine type | string | `"n1-standard-1"` | no |
| redis\_instance\_metadata | Redis instance metadata | map(string) | `<map>` | no |
| redis\_instance\_name | Redis vm name | string | `"redis"` | no |
| redis\_instance\_network | Redis instance network | string | `"default"` | no |
| redis\_instance\_region | Redis region | string | `"europe-west2"` | no |
| redis\_instance\_subnetwork | Redis instance subnetwork | string | `"default"` | no |
| redis\_instance\_tags | Tags to attach instance with | list(string) | `<list>` | no |
| redis\_instance\_zone | Redis default zone | string | `"europe-west2-a"` | no |
| redis\_listen\_port | Redis listen port | string | `"6379"` | no |

## Outputs

| Name | Description |
|------|-------------|
| redis\_firewall | Redis vm firewall name |
| redis\_instance\_internal\_ip | Redis vm internal ip |
| redis\_instance\_name | Redis vm name |
| redis\_instance\_public\_ip | Redis vm public ip |
| redis\_instance\_zone | Redis default zone |
| redis\_port | Redis listen port |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.12
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v2.0

### Service Account

A service account with the following roles must be used to provision
the resources of this module:

- Storage Admin: `roles/storage.admin`

The [Project Factory module][project-factory-module] and the
[IAM module][iam-module] may be used in combination to provision a
service account with the necessary roles applied.

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- Google Cloud Storage JSON API: `storage-api.googleapis.com`

The [Project Factory module][project-factory-module] can be used to
provision a project with the necessary APIs enabled.

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html
