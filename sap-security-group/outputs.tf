locals {
  key_name = var.is_scs ? join("-", [var.sysnr, "scs"]) : var.sysnr
}

output "sysnr_security_group_map" {
  #value = map(local.key_name, aws_security_group.default.arn)
  value = { sysnr : local.key_name,
    arn : aws_security_group.default.arn,
  id : aws_security_group.default.id }
}