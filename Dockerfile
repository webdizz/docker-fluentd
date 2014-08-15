FROM phusion/baseimage:0.9.9

MAINTAINER Izzet Mustafaiev "izzet@mustafaiev.com"


# Set correct environment variables.
ENV	HOME /root
ENV	LANG en_US.UTF-8
ENV	LC_ALL en_US.UTF-8
ENV	DEBIAN_FRONTEND	noninteractive

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# set sane locale
RUN	locale-gen en_US.UTF-8

RUN apt-get update && apt-get install -y -q curl libcurl3 sudo ruby-dev ruby1.9.1 ruby1.9.1-dev build-essential git libcurl3 libcurl3-gnutls libcurl4-openssl-dev

RUN ulimit -n 65536

# Install plugins
RUN sudo gem install fluentd fluent-plugin-elasticsearch fluent-plugin-riak fluent-plugin-kafka --no-rdoc fluent-plugin-redis --no-ri

# add init script
RUN mkdir -p /etc/service/fluentd
ADD fluentd.sh /etc/service/fluentd/run
RUN chmod +x /etc/service/fluentd/run
ADD configs/fluent.conf /etc/fluent/fluent.conf

# Expose ports.
EXPOSE 24224 8888

# Clean up APT when done.
RUN	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
