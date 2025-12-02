resource "docker_image" "nginx_image" {
  name = "nginx:latest"
}

resource "docker_container" "nginx" {
  name  = var.container_name
  image = docker_image.nginx_image.name   # <-- changed from .latest to .name
  networks_advanced {
    name = var.network_name
  }
  ports {
    internal = 80
    external = var.frontend_port
  }
}
