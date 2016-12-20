#!/bin/sh

export srcdir=pawpaw-server-$RANDOM
export workdir=`dirname $1`

# Copy ansible files into home folder
mkdir -p ~/ansible/$srcdir && \
  cp -r $workdir ~/ansible/$srcdir

# Copy ssh keys into home folder
mkdir ~/ansible/$srcdir/ssh-keys && \
  cp ~/.ssh/id_rsa ~/ansible/$srcdir/ssh-keys/id_rsa && \
  cp ~/.ssh/id_rsa.pub ~/ansible/$srcdir/ssh-keys/id_rsa.pub

# Stop and remove ansible_test before start
docker rm -f ansible_test

# Run ansible_test container and push ssh keys into it
docker run -d -p 2222:22 -p 8080:80 -p 45537:45537 --name ansible_test philm/ansible_target:latest
docker exec -u ubuntu ansible_test mkdir -p //home/ubuntu/.ssh
docker cp ~/.ssh/id_rsa.pub ansible_test:/home/ubuntu/.ssh/authorized_keys
docker exec ansible_test chown -R ubuntu: //home/ubuntu/.ssh
docker exec -u ubuntu ansible_test chmod 600 //home/ubuntu/.ssh/authorized_keys

# Run ansible container with link to ansible_test
export share=//c/Users
docker run -v /$share:$share -w $share/Artyom/ansible/$srcdir --rm -it --link ansible_test ansible -v $1 -i $2

# Remove all copies from the home folder
rm -rf ~/ansible/$srcdir
