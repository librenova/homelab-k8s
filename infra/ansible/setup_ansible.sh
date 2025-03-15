#!/bin/bash

# Define the root Ansible directory
ANSIBLE_DIR="ansible"

# Define all required subdirectories
declare -a FOLDERS=(
    "$ANSIBLE_DIR/playbooks"
    "$ANSIBLE_DIR/roles/common/tasks"
    "$ANSIBLE_DIR/roles/common/handlers"
    "$ANSIBLE_DIR/roles/common/templates"
    "$ANSIBLE_DIR/roles/common/files"
    "$ANSIBLE_DIR/roles/common/vars"
    "$ANSIBLE_DIR/roles/kubernetes/tasks"
    "$ANSIBLE_DIR/roles/kubernetes/handlers"
    "$ANSIBLE_DIR/roles/kubernetes/templates"
    "$ANSIBLE_DIR/roles/kubernetes/files"
    "$ANSIBLE_DIR/roles/kubernetes/vars"
    "$ANSIBLE_DIR/roles/security/tasks"
    "$ANSIBLE_DIR/roles/security/handlers"
    "$ANSIBLE_DIR/roles/security/templates"
    "$ANSIBLE_DIR/roles/security/files"
    "$ANSIBLE_DIR/roles/security/vars"
    "$ANSIBLE_DIR/inventory"
    "$ANSIBLE_DIR/group_vars"
    "$ANSIBLE_DIR/host_vars"
)

# Create folders
for folder in "${FOLDERS[@]}"; do
    mkdir -p "$folder"
done

# Create README files for each major section
echo "# 🔧 Ansible Playbooks for Automation" > "$ANSIBLE_DIR/playbooks/README.md"
echo "# 📂 Common Ansible Role" > "$ANSIBLE_DIR/roles/common/README.md"
echo "# ⎈ Kubernetes Deployment Role" > "$ANSIBLE_DIR/roles/kubernetes/README.md"
echo "# 🔐 Security Hardening Role" > "$ANSIBLE_DIR/roles/security/README.md"
echo "# 🏗️ Ansible Inventory" > "$ANSIBLE_DIR/inventory/README.md"

# --- Sample Ansible Playbooks ---
cat <<EOF > "$ANSIBLE_DIR/playbooks/setup-k8s.yml"
---
- name: Setup Kubernetes Cluster
  hosts: k8s_nodes
  become: yes
  roles:
    - role: kubernetes
EOF

cat <<EOF > "$ANSIBLE_DIR/playbooks/setup-security.yml"
---
- name: Apply Security Hardening
  hosts: all
  become: yes
  roles:
    - role: security
EOF

cat <<EOF > "$ANSIBLE_DIR/playbooks/common-tasks.yml"
---
- name: Common Configurations
  hosts: all
  become: yes
  roles:
    - role: common
EOF

# --- Sample Inventory Files ---
cat <<EOF > "$ANSIBLE_DIR/inventory/hosts"
[k8s_master]
k8s-master-01 ansible_host=192.168.1.10 ansible_user=root

[k8s_workers]
k8s-worker-01 ansible_host=192.168.1.11 ansible_user=root
k8s-worker-02 ansible_host=192.168.1.12 ansible_user=root

[all:vars]
ansible_python_interpreter=/usr/bin/python3
EOF

# --- Sample Group Variables ---
cat <<EOF > "$ANSIBLE_DIR/group_vars/all.yml"
---
# Global Variables
timezone: "UTC"
EOF

# --- Sample Host Variables ---
cat <<EOF > "$ANSIBLE_DIR/host_vars/k8s-master-01.yml"
---
# K8s Master Node Variables
kubernetes_role: "master"
EOF

# --- Sample Common Role Tasks ---
cat <<EOF > "$ANSIBLE_DIR/roles/common/tasks/main.yml"
---
- name: Install common packages
  apt:
    name:
      - curl
      - wget
      - vim
    state: present
EOF

# --- Sample Kubernetes Role Tasks ---
cat <<EOF > "$ANSIBLE_DIR/roles/kubernetes/tasks/main.yml"
---
- name: Install Kubernetes dependencies
  apt:
    name:
      - kubelet
      - kubeadm
      - kubectl
    state: present

- name: Initialize Kubernetes cluster
  shell: kubeadm init --apiserver-advertise-address=192.168.1.10 --pod-network-cidr=10.244.0.0/16
  when: inventory_hostname in groups['k8s_master']
EOF

# --- Sample Security Role Tasks ---
cat <<EOF > "$ANSIBLE_DIR/roles/security/tasks/main.yml"
---
- name: Enable UFW Firewall
  ufw:
    state: enabled

- name: Allow SSH
  ufw:
    rule: allow
    port: "22"
    proto: tcp

- name: Disable Root SSH Login
  lineinfile:
    path: /etc/ssh/sshd_config
    regexp: "^PermitRootLogin"
    line: "PermitRootLogin no"
  notify: Restart SSH
EOF

# --- Sample Handlers ---
cat <<EOF > "$ANSIBLE_DIR/roles/security/handlers/main.yml"
---
- name: Restart SSH
  service:
    name: ssh
    state: restarted
EOF

# --- Sample Templates (for Kubernetes kubeadm config) ---
cat <<EOF > "$ANSIBLE_DIR/roles/kubernetes/templates/kubeadm-config.yaml.j2"
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: stable
controlPlaneEndpoint: "{{ ansible_host }}"
networking:
  podSubnet: "10.244.0.0/16"
EOF

# Initialize Git repository
cd "$ANSIBLE_DIR"
git init
git add .
git commit -m "Initial commit: Ansible setup with playbooks, roles, and inventory"

echo "✅ Ansible folder structure and sample files created successfully."
