output "instance" {
  value = aws_instance.sap-abap
}

output "instance_role_name" {
  value = aws_iam_role.sap_abap.name
}

output "instance_role_id" {
  value = aws_iam_role.sap_abap.id
}

output "instance_role_arn" {
  value = aws_iam_role.sap_abap.arn
}


output "instance_security_group_name" {
  description = "The name of the security group created for the server."
  value       = aws_security_group.default.name
}

output "instance_security_group_id" {
  description = "The id of the security group created for the server."
  value       = aws_security_group.default.id
}

output "instance_security_group_arn" {
  description = "The arn of the security group created for the server."
  value       = aws_security_group.default.arn
}

output "swap_device" {
  description = "The provisioned swap device name."
  value       = aws_volume_attachment.swap.device_name
}