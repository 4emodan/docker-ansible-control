#!/bin/sh

echo ">>> Starting Ansible-control station"

echo ">>> Add SSH keys"
# Copy ssh keys from the predefined directory
mkdir -p /root/.ssh
cp ssh-keys/* /root/.ssh
chmod -R 600 /root/.ssh

# Start ssh-agent to enable ssh agent forwarding
eval `ssh-agent` > /dev/null
ssh-add ~/.ssh/id_rsa

echo ">>> Test if SSH agent forwarding works: $SSH_AUTH_SOCK"

echo ">>> Copy known_hosts file"
rm -f /root/.ssh/known_hosts
cp known_hosts /root/.ssh

echo ">>> Starting Ansible"
# Entrypoint
ansible-playbook "$@"

# Debug entrypoint
# sh
