#!/bin/bash

source config.conf

LOG_FILE="logs/monitor.log"

while true
do

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

#################################
# CPU Usage
#################################

CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d. -f1)

CPU_USAGE=$((100 - CPU_IDLE))

#################################
# Memory Usage
#################################

MEMORY_USAGE=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2 * 100}')

#################################
# Disk Usage
#################################

DISK_USAGE=$(df / | awk 'END {print $5}' | sed 's/%//')

#################################
# Logging
#################################

echo "$TIMESTAMP | CPU:$CPU_USAGE% | MEM:$MEMORY_USAGE% | DISK:$DISK_USAGE%" >> "$LOG_FILE"

#################################
# Alerts
#################################

if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]
then
    echo "$TIMESTAMP ALERT: CPU threshold crossed" >> alerts.log
fi

if [ "$MEMORY_USAGE" -gt "$MEMORY_THRESHOLD" ]
then
    echo "$TIMESTAMP ALERT: CPU threshold crossed" >> alerts.log
fi

if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]
then
    echo "$TIMESTAMP ALERT: CPU threshold crossed" >> alerts.log
fi

sleep "$INTERVAL"
done
