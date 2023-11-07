#!/bin/bash

# 로그 레벨 설정 (DEBUG, INFO, WARNING, ERROR)
log_level="INFO"

# 출력 파일 설정
log_file="memory_leak.log"

# 감지 주기 설정 (초)
detection_interval=30

log() {
    # 로그 레벨에 따라 로그 출력
    local level="$1"
    local message="$2"
    if [ "$log_level" == "DEBUG" ] || [ "$log_level" == "$level" ]; then
        echo "[$level] $(date +"%Y-%m-%d %H:%M:%S"): $message" >> "$log_file"
    fi
}

log "INFO" "Memory leak detection script started."

while true; do
    log "INFO" "Checking memory..."
    pids=($(ps -e -o pid=))
    for pid in "${pids[@]}"; do
        if [ -e /proc/"$pid"/status ]; then
            name=$(cat /proc/"$pid"/status | grep Name)
            if [[ "$name" == *Name* ]]; then
                cur_mem=($(cat /proc/"$pid"/status | grep VmData | tr -s ' '))
                if [ "${cur_mem[1]}" -gt 0 ]; then
                    log "INFO" "Checking PID: $pid ($name)"
                    log "INFO" "Current Memory Usage: ${cur_mem[1]} kB"
                    # 여기에서 메모리 누수 여부를 확인하고 조치를 취할 수 있습니다.
                fi
            fi
        fi
    done
    sleep "$detection_interval"
done
