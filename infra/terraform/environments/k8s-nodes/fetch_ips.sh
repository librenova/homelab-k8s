#!/bin/bash

# Fetch the IP address of the master node
MASTER_IP=$(ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa root@<master-node-ip> "hostname -I | awk '{print $1}'")
echo "Master node IP: $MASTER_IP"

# Fetch the IP address of the first worker node
WORKER_1_IP=$(ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa root@<worker-1-node-ip> "hostname -I | awk '{print $1}'")
echo "Worker node 1 IP: $WORKER_1_IP"

# Fetch the IP address of the second worker node
WORKER_2_IP=$(ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa root@<worker-2-node-ip> "hostname -I | awk '{print $1}'")
echo "Worker node 2 IP: $WORKER_2_IP"
