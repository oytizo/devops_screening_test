#!/bin/bash

# Configuration and output log definition
LOG_FILE="health_log.txt"

# 1. Fetch CPU Usage (Calculates inverse of idle time via top)
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')

# 2. Fetch Memory Usage (Percentage of Used vs Total RAM)
MEM_USAGE=$(free | grep Mem | awk '{printf "%.2f", $3/$2 * 100}')

# 3. Fetch Root Disk Volume Usage Percentage
DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//')

# Compile structured current ISO 8601 Timestamp 
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Format telemetry information entry
LOG_ENTRY="[$TIMESTAMP] CPU: ${CPU_USAGE}%, MEM: ${MEM_USAGE}%, DISK: ${DISK_USAGE}%"

# Append metric records to designated logging file
echo "$LOG_ENTRY" >> "$LOG_FILE"

# Evaluate target system safety alert limits
if [ "$DISK_USAGE" -gt 80 ]; then
    echo "[WARNING] Disk space high! (Current usage: ${DISK_USAGE}%)"
fi
