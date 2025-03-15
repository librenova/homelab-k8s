output "k8s_master_ips" {
  value = [for vm in var.vm_config : vm.network_ip if vm.role == "master"]
}

output "k8s_worker_ips" {
  value = [for vm in var.vm_config : vm.network_ip if vm.role == "worker"]
}
