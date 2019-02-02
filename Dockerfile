FROM gliderlabs/alpine:3.3

RUN \
  apk-install \
    curl \
    openssh-client \
    sshpass \
    python \
    py-boto \
    py-dateutil \
    py-httplib2 \
    py-jinja2 \
    py-paramiko \
    py-pip \
    py-setuptools \
    py-yaml \
    tar && \
  pip install --upgrade pip python-keyczar && \
  rm -rf /var/cache/apk/*

RUN mkdir /etc/ansible/ /ansible
RUN echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts

RUN \
  curl -fsSL https://github.com/ansible/ansible/archive/v2.4.6.0-1.tar.gz -o ansible.tar.gz && \
  tar -xzf ansible.tar.gz -C ansible --strip-components 1 && \
  rm -fr ansible.tar.gz /ansible/docs /ansible/examples /ansible/packaging

WORKDIR /ansible

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_SSH_PIPELINING True
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib

RUN mkdir /root/.ssh

ADD ssh-keys-ansible-playbook.sh /ansible
ADD ssh.config /root/.ssh/config

ENTRYPOINT ["/ansible/ssh-keys-ansible-playbook.sh"]
