#!/bin/sh
if [ -z ${MEMCACHED_ADDR} ]; then
    /bin/memcached_exporter
else
    /bin/memcached_exporter --memcached.address=MEMCACHED_ADDR:11211
fi