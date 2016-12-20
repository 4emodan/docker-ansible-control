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

# Run ansible container
export share=//c/Users
docker run -v /$share:$share -w $share/Artyom/ansible/$srcdir --rm -it ansible -v $1 -i $2

# Remove all copies from the home folder
rm -rf ~/ansible/$srcdir
