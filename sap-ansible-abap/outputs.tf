output "template" {
  description = "The ansible variable template to use for an SAP ABAP base system."
  value       = local.template
}

output "template_format" {
  description = "The format of the template generated."
  value       = local.template_type
}