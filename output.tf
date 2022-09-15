# get the id of the instances created on terraform apply
output "instance_id" {
  value =[ for id in aws_instance.ec2_instance: id.id]
}