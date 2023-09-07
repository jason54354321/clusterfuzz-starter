FROM ubuntu:20.04

RUN apt update

RUN apt install curl -y

RUN mkdir -p /usr/opt/clusterfuzz

RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-444.0.0-linux-x86_64.tar.gz

RUN tar -xf google-cloud-cli-444.0.0-linux-x86_64.tar.gz  -C /usr/opt/

RUN /usr/opt/google-cloud-sdk/install.sh --quiet --rc-path /root/.bashrc

RUN bash


CMD [ "bash" ]
