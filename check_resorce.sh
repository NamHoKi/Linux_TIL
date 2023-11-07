#!/bin/bash

# 출력 파일 및 간격 설정
output_file="system_metrics.log"
interval=5

# 헤더 라인 작성
echo "Timestamp,Memory Usage (%),CPU Usage (%)" > "$output_file"

while true; do
    # 현재 시간 기록 (ISO 8601 형식)
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    # 메모리 사용량 및 CPU 사용량 측정
    memory_usage=$(free | awk '/Mem:/ {printf "%.2f", $3/$2*100}')
    cpu_usage=$(top -bn1 | awk '/Cpu\(s\):/ {printf "%.2f", 100-$8}')

    # 결과를 파일에 추가
    echo "$timestamp,$memory_usage,$cpu_usage" >> "$output_file"

    # 주기적으로 측정 (5초)
    sleep $interval
done
