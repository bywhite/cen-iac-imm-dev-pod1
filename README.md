
# Creating servers in Intersight using Terraform Cloud for Business

This simple terraform plan for Intersight creates the minimum required pools and policies so that it can also create a server profile template and a domain profile.

To keep the code simple and compact, it references an Intersight policy bundle here:
https://github.com/bywhite/cen-iac-imm-dev-pod1-mods
based initially from Patrick's module:  https://github.com/pl247/tf-intersight-policy-bundle

The plan does not currently create a storage policy, so you will need to build that to your needs and reference it in your template.

### Directions

1. Create a workspace in TFCB called "cen-iac-imm-dev-pod1"

2. Edit the name of the backend organization variable in the main.tf to match that of your TFCB organization (the name of the grouping that holds all of your workspaces)

3. Add the following variables in your workspace:
    - api_key = the API Key ID you create in Intersight using version 2
    - secretkey (make sensitive) = the secretkey of your Intersight API key
    - endpoint = https://intersight.com    (a private appliance would have its own DNS name)

### Note about Terraform destroy

When attempting a `terraform destroy`, Terraform is unable to remove the policies that are in use (IE: by the domain profile). To get around this, you will have to delete the domain profile manually first and possibly any server profiles that are using any of the profiles or policies created.
