#!/bin/sh

exec /usr/local/bin/fluentd -v --conf=/etc/fluent/fluent.conf  2>&1
