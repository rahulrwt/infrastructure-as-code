locals {
  name_prefix = "${var.name_prefix}-monitoring"
  tags = merge(
    {
      Name      = local.name_prefix
      ManagedBy = "Terraform"
    },
    var.tags
  )
}