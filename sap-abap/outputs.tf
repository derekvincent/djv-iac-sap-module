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
    value = aws_security_group.default.arn
}

output "instance_security_group_id" {
    value = aws_security_group.default.arn
}

output "instance_security_group_arn" {
    value = aws_security_group.default.arn
}

output "swap_device" {
    value = aws_volume_attachment.swap.device_name
}