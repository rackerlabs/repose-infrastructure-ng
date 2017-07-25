#!/usr/bin/env bash

influxdb_performance_db=$1
influxdb_backups=$2

influxd backup -database $influxdb_performance_db /tmp${influxdb_backups}
DATE_EXT=$(date +%Y%m%d%H%M%S)
for file in /tmp${influxdb_backups}/*.[0-9][0-9] ; do
    gzip -S "_${DATE_EXT}.gz" $file
done
mv /tmp${influxdb_backups}/*.gz ${influxdb_backups}/
rm -Rf /tmp${influxdb_backups}
