Security Automation for Proxmox

📌 Overview

This folder contains security-related Terraform configurations, Ansible playbooks, and policies to secure the Proxmox infrastructure. It includes firewall rules, access controls, encryption settings, and monitoring configurations.
Manages RBAC, firewall rules, and Open Policy Agent configurations.

📂 Folder Structure

security/
│── terraform/
│   ├── firewall-rules.tf       # Defines firewall rules for Proxmox
│   ├── access-control.tf       # Configures user permissions and roles
│   ├── ssh-keys.tf             # Manages SSH key distribution
│   ├── variables.tf            # Defines security-related variables
│   ├── outputs.tf              # Outputs security-related configurations
│   ├── backend.tf              # Remote state backend for security settings
│── ansible/
│   ├── hardening.yml           # Playbook for system hardening
│   ├── fail2ban.yml            # Playbook to install and configure Fail2Ban
│   ├── auditd.yml              # Playbook to install and configure audit logs
│── policies/
│   ├── security-policy.md      # Documentation of security policies
│   ├── access-policy.md        # Role-based access control (RBAC) policies
│   ├── encryption-policy.md    # Data encryption standards and configurations
│── README.md                   # Security documentation

🔹 Terraform Security Configuration

1️⃣ Firewall Rules (firewall-rules.tf)

Defines Proxmox firewall rules to restrict access and mitigate unauthorized entry.

resource "proxmox_firewall_rule" "allow_ssh" {
  node   = "pve"
  action = "ACCEPT"
  proto  = "tcp"
  dport  = "22"
  source = "192.168.1.0/24"
}

2️⃣ Access Control (access-control.tf)

Manages user roles and permissions within Proxmox.

resource "proxmox_user" "admin" {
  userid   = "admin@pam"
  password = "securepassword"
  role     = "Administrator"
}

3️⃣ SSH Key Management (ssh-keys.tf)

Distributes secure SSH keys for access control.

resource "proxmox_ssh_key" "user_key" {
  user    = "root"
  key     = file("~/.ssh/id_rsa.pub")
}

🛠 Ansible Security Playbooks

1️⃣ System Hardening (hardening.yml)

- name: Apply system hardening
  hosts: all
  tasks:
    - name: Ensure UFW is installed
      apt:
        name: ufw
        state: present

2️⃣ Fail2Ban Protection (fail2ban.yml)

- name: Install and configure Fail2Ban
  hosts: all
  tasks:
    - name: Install Fail2Ban
      apt:
        name: fail2ban
        state: present

3️⃣ Audit Logging (auditd.yml)

- name: Install audit logging
  hosts: all
  tasks:
    - name: Ensure auditd is installed
      apt:
        name: auditd
        state: present

📜 Security Policies

1️⃣ Security Policy (security-policy.md)

Defines security best practices and compliance requirements.

Covers network security, user management, and encryption policies.

2️⃣ Access Policy (access-policy.md)

Establishes RBAC (Role-Based Access Control) guidelines.

Defines admin, user, and read-only roles for Proxmox.

3️⃣ Encryption Policy (encryption-policy.md)

Details data encryption standards for storage and transmission.

Specifies TLS for API communication and encrypted backups.

🚀 Next Steps

Implement Zero Trust Security Model.

Automate compliance checks using Terraform Sentinel.

Enable Proxmox API authentication logging.