variable "image_name" { default = "backend-app" }
variable "container_name" { default = "tf_backend" }
variable "network_name" { default = "tf_local_net" }
variable "db_host" { default = "tf_postgres" }
variable "db_user" { default = "appuser" }
variable "db_password" { default = "" }
variable "db_name" { default = "appdb" }
