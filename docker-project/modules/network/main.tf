resource "docker_network" "this" {
  name = var.name
}

output "network_name" {
  value = docker_network.this.name
}
