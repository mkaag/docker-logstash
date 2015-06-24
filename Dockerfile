FROM mkaag/baseimage:latest
MAINTAINER Maurice Kaag <mkaag@me.com>

# -----------------------------------------------------------------------------
# Environment variables
# -----------------------------------------------------------------------------
ENV LS_VERSION    1.5.1
ENV JAVA_VERSION  7

# -----------------------------------------------------------------------------
# Pre-install
# -----------------------------------------------------------------------------
RUN \
  echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update -qqy && \
  apt-get install -qqy oracle-java$JAVA_VERSION-installer && \
  rm -rf /var/cache/oracle-jdk$JAVA_VERSION-installer
ENV JAVA_HOME /usr/lib/jvm/java-$JAVA_VERSION-oracle

# -----------------------------------------------------------------------------
# Install
# -----------------------------------------------------------------------------
WORKDIR /opt
RUN \
  curl -s -O https://download.elasticsearch.org/logstash/logstash/logstash-$LS_VERSION.tar.gz && \
  tar xvzf logstash-$LS_VERSION.tar.gz && \
  rm -f logstash-$LS_VERSION.tar.gz && \
  ln -s /opt/logstash-$LS_VERSION /opt/logstash && \
  /opt/logstash/bin/plugin -i contrib

# -----------------------------------------------------------------------------
# Post-install
# -----------------------------------------------------------------------------
RUN mkdir /etc/service/logstash
ADD build/logstash.sh /etc/service/logstash/run
RUN chmod +x /etc/service/logstash/run

EXPOSE 5140 5000
VOLUME ["/opt/etc"]

CMD ["/sbin/my_init"]

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
