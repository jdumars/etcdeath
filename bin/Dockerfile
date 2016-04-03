FROM ubuntu:trusty

MAINTAINER jdumars@deis.com

RUN \
    apt-get update \
 && apt-get -y install \
       curl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN \
     curl -L  https://github.com/coreos/etcd/releases/download/v2.3.1/etcd-v2.3.1-linux-amd64.tar.gz -o etcd-v2.3.1-linux-amd64.tar.gz \ 
  &&  tar xzvf etcd-v2.3.1-linux-amd64.tar.gz \
  &&  mv etcd-v2.3.1-linux-amd64.tar.gz /opt/etcd

ADD expose.sh /expose.sh

CMD bash /expose.sh
