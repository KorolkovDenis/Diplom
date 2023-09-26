#Network

resource "yandex_vpc_network" "diplom-network" {

name = "korolkov-network-diplom"
}

# Subnet web-srv-1

resource "yandex_vpc_subnet" "web-srv-1" {

  name           = "web-srv-1"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["192.168.1.0/24"]
  network_id     = "${yandex_vpc_network.diplom-network.id}"
}

# Subnet web-srv-2

resource "yandex_vpc_subnet" "web-srv-2" {

  name           = "web-srv-2"
  zone           = "ru-central1-b"
  v4_cidr_blocks = ["192.168.2.0/24"]
  network_id     = "${yandex_vpc_network.diplom-network.id}"
}

# Subnet zabbix

resource "yandex_vpc_subnet" "subnet-zabbix" {

  name           = "subnet-zabbix"
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["192.168.3.0/24"]
  network_id     = "${yandex_vpc_network.diplom-network.id}"
}

# Subnet grafana

resource "yandex_vpc_subnet" "subnet-grafana" {

  name           = "subnet-grafana"
  zone           = "ru-central1-b"
  v4_cidr_blocks = ["192.168.4.0/24"]
  network_id     = "${yandex_vpc_network.diplom-network.id}"
}

# Subnet elasticsearch

resource "yandex_vpc_subnet" "subnet-elasticsearch" {

  name           = "subnet-elasticsearch"
  zone           = "ru-central1-b"
  v4_cidr_blocks = ["192.168.5.0/24"]
  network_id     = "${yandex_vpc_network.diplom-network.id}"
}

# Subnet kibana

resource "yandex_vpc_subnet" "subnet-kibana" {

  name           = "subnet-kibana"
  zone           = "ru-central1-b"
  v4_cidr_blocks = ["192.168.6.0/24"]
  network_id     = "${yandex_vpc_network.diplom-network.id}"
}

# Subnet sshgw

resource "yandex_vpc_subnet" "subnet-ssh-gw" {

  name           = "subnet-ssh-gw"
  zone           = "ru-central1-b"
  v4_cidr_blocks = ["192.168.7.0/24"]
  network_id     = "${yandex_vpc_network.diplom-network.id}"
}

# alb address

resource "yandex_vpc_address" "addr-1" {
  name = "addr-1"

  external_ipv4_address {
    zone_id                  = "ru-central1-a"
  }
}

# Target group for ALB

resource "yandex_alb_target_group" "tg-1" {
  name = "tg-1"

  target { 
    subnet_id  = yandex_compute_instance.web-srv-1.network_interface.0.subnet_id
    ip_address = yandex_compute_instance.web-srv-1.network_interface.0.ip_address
  }

  target {
    subnet_id  = yandex_compute_instance.web-srv-2.network_interface.0.subnet_id
    ip_address = yandex_compute_instance.web-srv-2.network_interface.0.ip_address
  }
}

# Backend group for ALB

resource "yandex_alb_backend_group" "bg-1" {
  name = "bg-1"

  http_backend {
    name             = "backend-1"
    weight           = 1
    port             = 80
    target_group_ids = ["${yandex_alb_target_group.tg-1.id}"]
    
    load_balancing_config {
      panic_threshold = 9
    }
    healthcheck {
      timeout  = "5s"
      interval = "2s"     
      healthy_threshold    = 2
      unhealthy_threshold  = 15 
      http_healthcheck {
        path               = "/"
      }
    }
  }
}

# ALB router

resource "yandex_alb_http_router" "router-1" {
  name = "router-1"
}

# ALB virtual host

resource "yandex_alb_virtual_host" "vh-1" {
  name           = "vh-1"
  http_router_id = yandex_alb_http_router.router-1.id

  route {
    name = "route-1"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.bg-1.id
        timeout          = "3s"
      }
    }
  }  
}

# ALB

resource "yandex_alb_load_balancer" "alb-1" {
  name               = "alb-1"
  network_id         = yandex_vpc_network.diplom-network.id
  security_group_ids = [yandex_vpc_security_group.sg-balancer.id]

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.web-srv-1.id
    }

    location {
      zone_id   = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.web-srv-2.id
    }
  }

  listener {
    name = "listener-1"
    endpoint {
      address {
        external_ipv4_address {
          address = yandex_vpc_address.addr-1.external_ipv4_address[0].address
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.router-1.id 
      }
    }
  }
}
