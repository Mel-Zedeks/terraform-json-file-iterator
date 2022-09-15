
# create resource by iterating over the json file content
resource "aws_instance" "ec2_instance" {
  for_each      = var.instances
  ami           = each.value.ami
  instance_type = each.value.instance_type
  tags          = each.value.tags
  key_name      = each.value.key_name
}