FROM phusion/baseimage:latest

MAINTAINER Maurice Kaag <mkaag@me.com>

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_PRIORITY critical
ENV DEBCONF_NOWARNINGS yes
# Workaround initramfs-tools running on kernel 'upgrade': <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189>
ENV INITRD No

# Workaround initscripts trying to mess with /dev/shm: <https://bugs.launchpad.net/launchpad/+bug/974584>
# Used by our `src/ischroot` binary to behave in our custom way, to always say we are in a chroot.
ENV FAKE_CHROOT 1
RUN mv /usr/bin/ischroot /usr/bin/ischroot.original
ADD build/ischroot /usr/bin/ischroot

# Configure no init scripts to run on package updates.
ADD build/policy-rc.d /usr/sbin/policy-rc.d

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Ensure UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

# Java Installation
RUN \
  echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update -qqy && \
  apt-get install -qqy oracle-java7-installer && \
  rm -rf /var/cache/oracle-jdk7-installer
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

# Logstash Installation
WORKDIR /opt
RUN \
  curl -s -O https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz && \
  tar xvzf logstash-1.4.2.tar.gz && \
  rm -f logstash-1.4.2.tar.gz && \
  ln -s /opt/logstash-1.4.2 /opt/logstash && \
  /opt/logstash/bin/plugin -i contrib

RUN mkdir /etc/service/logstash
ADD build/logstash.sh /etc/service/logstash/run
RUN chmod +x /etc/service/logstash/run

VOLUME ["/opt/etc"]
EXPOSE 5140 5000

CMD ["/sbin/my_init"]
# End Installation

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
