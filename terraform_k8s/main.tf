provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

resource "yandex_kubernetes_cluster" "cluster" {
  name                    = "crawler"
  folder_id               = var.folder_id
  network_id              = var.network_id
  service_account_id      = var.service_account_id
  node_service_account_id = var.service_account_id
  release_channel         = "RAPID"
  network_policy_provider = "CALICO"

  master {
    version   = "1.19"
    public_ip = true

    zonal {
      zone      = var.zone
      subnet_id = var.subnet_id
    }
  }
}

resource "yandex_kubernetes_node_group" "node_groups" {
  cluster_id  = yandex_kubernetes_cluster.cluster.id
  name        = "crawler-group"
  version     = "1.19"

  instance_template {
    platform_id = "standard-v2"
    nat         = true
    metadata = {
      ssh-keys = "ubuntu:${var.public_key}"
    }

    resources {
      cores  = 4
      memory = 8
    }
    boot_disk {
      size = 64
    }

  }
  scale_policy {
    fixed_scale {
      size = 2
    }
  }
}
