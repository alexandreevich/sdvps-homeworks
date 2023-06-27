terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = "t1.9euelZqei5yZnImLkYmVjouclY2Yku3rnpWalY6Px5mVkJGczsaOmYuNipHl8_cLXxhb-e9eHjhp_d3z90sNFlv5714eOGn9zef1656VmpTOz4yZmciOzsyOlsnMzInG7_zN5_XrnpWai5LJxo2VlJObx5ePjo6QzJnv_cXrnpWalM7PjJmZyI7OzI6WyczMicY.dD-_SgprS1LZXxGyRODEIYAStFqsuF6i2TAcTJE70KPN2VeEzH6QnqjeuxBXxMczxM4ptaGI6hnxsV83VIiDAw"
  cloud_id  = "b1gmu1irj224ell4hff6"
  folder_id = "b1gfrgsjal35a5ev7q1e" 
  zone = "ru-central1-b"
}

resource "yandex_compute_instance" "vm-1" {
  name = "terraform1"

  resources {
    core_fraction = 20
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8oshj0osht8svg6rfs"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
 metadata = {
    user-data = "${file("./meta.txt")}"
  }

}
resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}
output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

