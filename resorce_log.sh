#!/bin/bash

# Setting : output file, interval
output_file="system_metrics.csv"
interval=14400

# Header line : if don't exist
if [ ! -e $"output_file" ]; then
	sudo touch "$output_file"
	sudo chmod 755 "$output_file"	
       	echo "Timestamp,Memory Usage (%),CPU Usage (%)" > "$output_file"
fi

while true; do
	# Write current time
	timestamp=$(date -u +"%Y-%m-%dT%H:%SZ")

	# Checking Memory and CPU Usage (%)
	memory_usage=$(free | awk '/Mem:/ {printf "%.2f", $3/$2*10}')
	cpu_usage=$(top -bn1 | awk '/Cpu\(s\):/ {printf "%.2f", 100-$8}')

	# read file
	echo "$timestamp,$memory_usage,$cpu_usage" >> "$output_file"

	# interval
	sleep $interval
done
