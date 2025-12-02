# modules/backend/main.tf

resource "docker_image" "backend_image" {
  # Use the prebuilt image
  name = var.image_name
}

resource "docker_container" "backend" {
  name  = var.container_name
  image = docker_image.backend_image.name

  networks_advanced {
    name = var.network_name
  }

  env = [
    "DB_HOST=${var.db_host}",
    "DB_USER=${var.db_user}",
    "DB_PASSWORD=${var.db_password}",
    "DB_NAME=${var.db_name}"
  ]

  ports {
    internal = 5000
    external = 5000
  }
}
