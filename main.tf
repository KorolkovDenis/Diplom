terraform {
  required_providers {
    yandex = {
     source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
#  token     = ""
  service_account_key_file = "key.json"
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}


#создание авторизованного ключа для сервисного аккаунта root
# yc iam key create --service-account-name root -o root-key.json


#пример:
#metadata = {
#  foo = "bar"
#  ssh-key = "root:${file("~/ssh/id_rsa.pub)}
#  }

#  user-data = "${file("./meta-web-srv-1.yml")}"

# Web Server 1

resource "yandex_compute_instance" "web-srv-1" {

  name     = "web-srv-1"
  zone     = "ru-central1-a"
  hostname = "web-srv-1.srv."

  scheduling_policy {
    preemptible = true
  }

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8dfofgv8k45mqv25nq"
      size     = 15
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.web-srv-1.id}"
    dns_record {
      fqdn = "web-srv-1.srv."
    ttl = 300
    }
    nat = true
    security_group_ids = [yandex_vpc_security_group.sg-private.id]
  }

  metadata = {

    user-data = "${file("./meta-web-srv-1.yml")}"
  }
}

# Web Server 2

resource "yandex_compute_instance" "web-srv-2" {

  name     = "web-srv-2"
  zone     = "ru-central1-b"
  hostname = "web-srv-2.srv."

  scheduling_policy {
    preemptible = true
  }

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8dfofgv8k45mqv25nq"
      size     = 15
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.web-srv-2.id}"
    dns_record {
      fqdn = "web-srv-2.srv."
    ttl = 300
    }
    nat = true
    security_group_ids = [yandex_vpc_security_group.sg-private.id]
  }

  metadata = {

    user-data = "${file("./meta-web-srv-2.yml")}"
  }
}


# Zabbix Server

resource "yandex_compute_instance" "zabbix" {

  name     = "zabbix"
  zone     = "ru-central1-a"
  hostname = "zabbix.srv."

  scheduling_policy {
    preemptible = true
  }

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8dfofgv8k45mqv25nq"
      size     = 15
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-zabbix.id}"
    dns_record {
      fqdn = "zabbix.srv."
    ttl = 300
    }
    nat = true
    security_group_ids = [yandex_vpc_security_group.sg-private.id]
  }

  metadata = {

    user-data = "${file("./meta-zabbix.yml")}"
  }
}

# Grafana Server

resource "yandex_compute_instance" "grafana" {

  name     = "grafana"
  zone     = "ru-central1-b"
  hostname = "grafana.srv."

  scheduling_policy {
    preemptible = true
  }

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8dfofgv8k45mqv25nq"
      size     = 10
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-grafana.id}"
    dns_record {
      fqdn = "gtafana.srv."
    ttl = 300
    }
    nat = true
    security_group_ids = [yandex_vpc_security_group.sg-public.id]
  }

  metadata = {

    user-data = "${file("./meta-grafana.yml")}"
  }
}

# ElasticSearch Server

resource "yandex_compute_instance" "elasticsearch" {

  name     = "elasticsearch"
  zone     = "ru-central1-b"
  hostname = "elasticsearch.srv."

  scheduling_policy {
    preemptible = true
  }

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 8
  }

  boot_disk {
    initialize_params {
      image_id = "fd8dfofgv8k45mqv25nq"
      size     = 15
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-elasticsearch.id}"
    dns_record {
      fqdn = "elastic.srv."
    ttl = 300
    }
    nat = true
    security_group_ids = [yandex_vpc_security_group.sg-private.id]
  }

  metadata = {

    user-data = "${file("./meta-elasticsearch.yml")}"
  }
}

# Kibana server

resource "yandex_compute_instance" "kibana" {

  name     = "kibana"
  zone     = "ru-central1-b"
  hostname = "kibana.srv."

  scheduling_policy {
    preemptible = true
  }

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 8
  }

  boot_disk {
    initialize_params {
      image_id = "fd8dfofgv8k45mqv25nq"
      size     = 15
    }
  }


  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-kibana.id}"
    dns_record {
      fqdn = "kibana.srv."
    ttl = 300
    }
    nat = true
    security_group_ids = [yandex_vpc_security_group.sg-public.id]
  }

  metadata = {

    user-data = "${file("./meta-kibana.yml")}"
  }
}

# Gateway Server
# bastion host

resource "yandex_compute_instance" "ssh-gw" {

  name     = "ssh-gw"
  zone     = "ru-central1-b"
  hostname = "ssh-gw.srv."

  scheduling_policy {
    preemptible = true
  }

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8dfofgv8k45mqv25nq"
      size     = 10
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-ssh-gw.id}"
    dns_record {
      fqdn = "ssh-gw.srv."
    ttl = 300
    }
    nat = true
    security_group_ids = [yandex_vpc_security_group.sg-ssh-gw.id]
  }

  metadata = {

    user-data = "${file("./meta-ssh-gw.yml")}"
  }
}
