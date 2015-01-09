#!/usr/bin/env bash
set -e

LOGSTASH_CONFIG=${LOGSTASH_CONFIG:-/opt/etc/conf.d}
LOGSTASH_OUTPUT=${LOGSTASH_OUTPUT:-30-outputs.conf}

sed -i "s/elasticsearch { host => \".*\" }/elasticsearch { host => \"${ES_PORT_9200_TCP_ADDR}\" }/g" $LOGSTASH_CONFIG/$LOGSTASH_OUTPUT

/opt/logstash/bin/logstash --config $LOGSTASH_CONFIG
