output "internal-web-srv-1" {
  value = yandex_compute_instance.web-srv-1.network_interface.0.ip_address
}

output "internal-web-srv-2" {
  value = yandex_compute_instance.web-srv-2.network_interface.0.ip_address
}

output "internal-zabbix" {
  value = yandex_compute_instance.zabbix.network_interface.0.ip_address
}

output "internal-grafana" {
  value = yandex_compute_instance.grafana.network_interface.0.ip_address
}
output "external-grafana" {
  value = yandex_compute_instance.grafana.network_interface.0.nat_ip_address
}

output "internal-elasticsearch" {
  value = yandex_compute_instance.elasticsearch.network_interface.0.ip_address
}

output "internal-kibana" {
  value = yandex_compute_instance.kibana.network_interface.0.ip_address
}
output "external-kibana" {
  value = yandex_compute_instance.kibana.network_interface.0.nat_ip_address
}

output "internal-ssh-gw" {
  value = yandex_compute_instance.ssh-gw.network_interface.0.ip_address
}
output "external-ssh-gw" {
  value = yandex_compute_instance.ssh-gw.network_interface.0.nat_ip_address
}

output "external-alb" {
  value = yandex_vpc_address.addr-1.external_ipv4_address[0].address
}
