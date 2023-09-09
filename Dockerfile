FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt update

RUN apt install curl -y

RUN mkdir -p /usr/opt/clusterfuzz

# gcloud
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-444.0.0-linux-x86_64.tar.gz

RUN tar -xf google-cloud-cli-444.0.0-linux-x86_64.tar.gz  -C /usr/opt/

RUN /usr/opt/google-cloud-sdk/install.sh --quiet --rc-path /root/.bashrc && bash


# clone clusterfuzz
RUN apt install git -y \
	&& apt install sudo -y

WORKDIR '/root/dev'

RUN git clone https://github.com/google/clusterfuzz

WORKDIR '/root/dev/clusterfuzz'

RUN git checkout tags/v2.6.0

# golang
RUN curl -O https://dl.google.com/go/go1.21.0.linux-amd64.tar.gz

RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz

ENV PATH="${PATH}:/usr/local/go/bin"

# python3.7
RUN apt-get install software-properties-common -y \
	&& add-apt-repository ppa:deadsnakes/ppa \
	&& apt-get update

RUN apt install -y python3.7 \
	&& apt install pipenv python3-pip -y

# RUN apt-get -y purge python3.8
# RUN rm /usr/bin/python3
# RUN cp /usr/bin/python3.7 /usr/bin/python3

# install clusterfuzz dependencies
WORKDIR '/root/dev/clusterfuzz'

RUN local/install_deps.bash

RUN echo "export SHELL=/bin/bash" >> /root/.bashrc

RUN pip install google-cloud-ndb
RUN pip install oauth2client
RUN pip install google-api-python-client

RUN apt-get install -y google-cloud-sdk
COPY ./test.sh .
RUN chmod +x ./test.sh


CMD [ "/bin/bash" ]
