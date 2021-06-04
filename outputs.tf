output "AWS_account_ID" {
value = data.aws_caller_identity.current.account_id
}
output "AWS_user_ID" {
value = data.aws_caller_identity.current.user_id
}
output "AWS_region_id" {
  value = data.aws_region.current.id
}
output "EC2_private_ip" {
value =aws_instance.test.*.private_ip
}
output "EC2_subnetwork_id" {
value = aws_instance.test.*.subnet_id
}
