resource "docker_container" "postgres" {
  name  = var.container_name
  image = "postgres:15"
  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}"
  ]
  networks_advanced {
    name = var.network_name
  }
  ports {
    internal = 5432
    external = 5432
  }
}
