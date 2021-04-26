output "ricky_image_id" {
  value = var.image_id
}

output "ricky_availability_zone_names" {
  value = var.availability_zone_names
}

output "ricky_ami_id_maps" {
  value = var.ami_id_maps
}

output "ricky_first_availability_zone_names" {
  value = var.availability_zone_names[0]
}
