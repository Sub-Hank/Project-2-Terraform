provider "kubernetes" {
  config_path = "./k3d-tf-cluster.kubeconfig"
}

# Namespace
resource "kubernetes_namespace" "example" {
  metadata {
    name = "example-namespace"
  }
}

# ConfigMap
resource "kubernetes_config_map" "nginx_config" {
  metadata {
    name      = "nginx-config"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  data = {
    "nginx.conf" = <<EOF
events { }
http {
    server {
        listen 80;
        location / {
            return 200 'Hello from Nginx ConfigMap!';
        }
    }
}
EOF
  }
}

# Deployment with resource requests/limits and ConfigMap mount
resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"

          port {
            container_port = 80
          }

          # Enhancement: resource requests and limits
          resources {
            requests = {
              cpu    = "50m"
              memory = "64Mi"
            }
            limits = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          # Mount the ConfigMap
          volume_mount {
            name       = "nginx-config-volume"
            mount_path = "/etc/nginx/nginx.conf"
            sub_path   = "nginx.conf"
          }
        }

        # Define the volume here at the pod spec level
        volume {
          name = "nginx-config-volume"

          config_map {
            name = kubernetes_config_map.nginx_config.metadata[0].name
            items {
              key  = "nginx.conf"
              path = "nginx.conf"
            }
          }
        }
      }
    }
  }
}

# Service
resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    selector = {
      app = "nginx"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}
