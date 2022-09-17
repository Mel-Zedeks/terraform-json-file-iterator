#terraform {
#  required_providers {
#    azurerm={
#      source="hashicorp/azurerm"
#      version = "3.23.0"
#    }
#  }
#}
#
#provider "azurerm" {
#  subscription_id = "12313"
#  features {}
#}

locals {
  # get json
  resource_data = jsondecode(file("${path.module}/mel.json"))

  # get all users
  resource_groups         = {for resource_group in local.resource_data.resource_groups : resource_group.name => resource_group}
  resource_group_children = concat(flatten( [ for group in local.resource_groups :[for child in group.children :child]]))
  wan_children = concat(flatten( [ for wan in local.resource_group_children :[for child in wan.children :child]]))
#{ for key,child in local.resource_group_children : "${ child.name }_${key}" => child }
#  resource_groups_keys = keys(local.resource_group_children)
  #if length(group.children)!=0
}

#output "resource_groups" {
#  value = local.wan_children
#}

resource "local_file" "resource_group" {
  for_each = local.resource_groups
  content = "Location is ${each.value.location} and name is ${each.value.name}"
  filename = "${path.module}/resources/${each.value.name}/${each.value.name}.text"
}


resource "local_file" "virtual_wan" {
  for_each = { for key,child in local.resource_group_children : "${ child.name }_${key}" => child }
  content = "Location is ${length(each.value)!=0?
  (each.value.location=="parent_location"?local_file.resource_group[each.value.parent_name].content:each.value.location )
  :""} and name is ${length(each.value)!=0?each.value.name:""}" #keyword replacing
  filename = "${path.module}/resources/${length(each.value)!=0?each.value.parent_name:"no-parent"}/${length(each.value)!=0?each.value.name:"d"}.text"
}

resource "local_file" "virtual_hub" {
  for_each = { for key,child in local.wan_children : "${ child.name }_${key}" => child }
  content = each.value.name
  filename = "${path.module}/resources/${length(each.value)!=0?each.value.parent_name:"no-parent"}/${length(each.value)!=0?each.value.name:"d"}.text"
}

