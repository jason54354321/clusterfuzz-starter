FROM ubuntu:20.04

RUN apt update

RUN apt install curl -y

RUN mkdir -p /usr/opt/clusterfuzz

RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-444.0.0-linux-x86_64.tar.gz

RUN tar -xf google-cloud-cli-444.0.0-linux-x86_64.tar.gz  -C /usr/opt/

RUN /usr/opt/google-cloud-sdk/install.sh --quiet --rc-path /root/.bashrc && bash

# python
RUN apt-get install software-properties-common -y \
	&& add-apt-repository ppa:deadsnakes/ppa \
	&& apt-get update

RUN apt install python3.7 -y \
	&& apt install pipenv python3-pip -y

# golang
RUN curl -O https://dl.google.com/go/go1.21.0.linux-amd64.tar.gz

RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz

ENV PATH="${PATH}:/usr/local/go/bin"

# clone clusterfuzz
RUN apt install git -y \
	&& apt install sudo -y

WORKDIR '/root/dev'

RUN git clone https://github.com/google/clusterfuzz

WORKDIR '/root/dev/clusterfuzz'

RUN git checkout tags/v2.6.0

RUN local/install_deps.bash

RUN echo "export SHELL=/bin/bash" >> /root/.bashrc


CMD [ "bash" ]
