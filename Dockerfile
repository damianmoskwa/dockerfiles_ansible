FROM ubuntu:latest

RUN apt-get update -y
    #DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends &&\
RUN apt-get install -y software-properties-common

RUN apt-add-repository ppa:ansible/ansible
RUN apt-get update && \
	apt-get install -y ansible \
	openssh-server \
	vim \
	sudo \
	&& \
    apt-get clean
	
RUN mkdir /var/run/sshd

RUN useradd -G ssh ssh_master
RUN mkdir -p /home/ssh_master/.ssh && chmod 700 /home/ssh_master/.ssh &&  echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAzKn5MP0MpuOSlkN9G3kNDt8vGIBp3sb2gTMPWITgrkR3OmM44Oa2zC+q0aMzRgCr13EjQfS+JOzi31ZvLu0nDrVgvXDHREJsG505m6sH3iW8LXyf+a+lpS+YJnBffuPkxRpZSYt1EYudeZitIDgIs2UqrORCfvqQESGd2k4/93IbUyqXOCqxKNj4DuQFPTHPQ3aKcaMsiPZGAQJ4ZHY8WmwGG0qaUOwADWIBJwF22D5N2K6OmxTCnIEo6hScqDtmzfEcCJAdALPtMmQh1aqkz400WZ46hzo1VgOtwq7STbdXCijBo/6DW1v28jatZ2h5vARs6u+L8dP1fZgIia3pzQ== ssh_master">>/home/ssh_master/.ssh/authorized_keys && chmod 600 /home/ssh_master/.ssh/authorized_keys 
RUN echo "ssh_master ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN sed -i 's/#PubkeyAuthentication/PubkeyAuthentication/' /etc/ssh/sshd_config

COPY keys/rsa.txt /home/ssh_master/.ssh/id_rsa
COPY keys/rsa_pub.txt /home/ssh_master/.ssh/id_rsa.pub

RUN chmod 600 /home/ssh_master/.ssh/id_rsa && chmod 644 /home/ssh_master/.ssh/id_rsa.pub

RUN chown -R  ssh_master:ssh_master /home/ssh_master

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
	
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]