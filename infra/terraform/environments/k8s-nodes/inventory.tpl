[masters]
master-node ansible_host=${master_ip} ansible_user=root

[workers]
%{ for ip in worker_ips }
worker-node ansible_host=${ip} ansible_user=root
%{ endfor }
