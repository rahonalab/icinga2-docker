#!/bin/bash
for f in $1/*
do
echo “Processing $f”
snmpttconvertmib -in=$f -out=/etc/snmp/snmptt.conf  -exec='echo "[$@] PROCESS_SERVICE_CHECK_RESULT;$A;$1;$2;$3" >> /var/run/icinga2/cmd/icinga2.cmd'
done
