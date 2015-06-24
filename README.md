## logstash Dockerfile

[![Docker Hub](https://img.shields.io/badge/docker-mkaag%2Flogstash-008bb8.svg)](https://registry.hub.docker.com/u/mkaag/logstash/)

This repository contains the **Dockerfile** and the configuration files of [Logstash](http://www.elasticsearch.org/overview/logstash/) for [Docker](https://www.docker.com/).

### Base Docker Image

* [phusion/baseimage](https://github.com/phusion/baseimage-docker), the *minimal Ubuntu base image modified for Docker-friendliness*...
* ...[including image's enhancement](https://github.com/racker/docker-ubuntu-with-updates) from [Paul Querna](https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/)

### Installation

`docker build -t mkaag/logstash github.com/mkaag/docker-logstash`

### Usage

``bash
docker run -d -p 5140:5140/tcp -p 5140:5140/udp -p 5000 \
--link elasticsearch:es \
-v /opt/apps/logstash:/opt/etc \
mkaag/logstash
```
