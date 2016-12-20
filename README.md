# Docker Ansible image
This repo follows the solution described in [Phil Misiowiec's article](https://medium.com/@tech_phil/running-ansible-inside-docker-550d3bb2bdff#.ypxxakbyx "Running Ansible Inside Docker") to run playbooks inside a Docker container and test them against another dedicated container.

Two things added to the solution - a __wrapper script__ (`ssh-keys-ansible-playbook.sh`) and __run scripts__ (`ansible-control-run.sh` and `ansible-control-test.sh`).

Run scripts added to overcome Docker restrictions on Windows:
* There are [issues](http://stackoverflow.com/questions/34161352/docker-sharing-a-volume-on-windows-with-docker-toolbox) with shared folders on Windows. Docker shares C:\Users folder by default, so all Ansible files need to be copied there.
* Shared folder is created with a random name each time. Docker doesn't see updated content otherwise.
* SSH keys being copied from ~/.ssh into the shared folder

Wrapper script needed to apply SSH keys inside the container and start ssh-agent to enable __ssh-agent forwarding__. Sufficient SSH config provided too.

# Usage
`sh /path/to/ansible-control-run.sh playbook.yml inventory.ini` or
`sh /path/to/ansible-control-test.sh playbook-test.yml inventory.ini`

# Restrictions
Some path variables and docker parameters are hardcoded, so the scripts are not ready as-is. 
