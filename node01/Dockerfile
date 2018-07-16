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

RUN useradd -G ssh ssh_node

RUN mkdir -p /home/ssh_node/.ssh && chmod 700 /home/ssh_node/.ssh 
COPY keys/node_auth.txt /home/ssh_node/.ssh/authorized_keys
RUN chmod 600 /home/ssh_node/.ssh/authorized_keys 
RUN chown -R  ssh_node /home/ssh_node

RUN echo "ssh_node ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN sed -i 's/#PubkeyAuthentication/PubkeyAuthentication/' /etc/ssh/sshd_config


ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
	
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]