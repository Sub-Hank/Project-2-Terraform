module "network" {
  source = "./modules/network"
}

module "database" {
  source       = "./modules/database"
  network_name = module.network.network_name
  db_user      = "appuser"
  db_password  = "S3cretPassw0rd"
  db_name      = "appdb"
}

module "backend" {
  source       = "./modules/backend"
  network_name = module.network.network_name
  db_user      = "appuser"
  db_password  = "S3cretPassw0rd"
  db_name      = "appdb"
}

module "frontend" {
  source        = "./modules/frontend"
  network_name  = module.network.network_name
  frontend_port = 8080
}
