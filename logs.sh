#!/bin/bash

log_file="/path/to/your/logfile.txt"
temp_file="/path/to/your/tempfile.txt"

# 이전 로그 파일에서 마지막으로 기록한 위치 찾기
if [ -e "$log_file" ]; then
    last_line=$(tail -n 1 "$log_file")
    last_line_marker="0"
    if [ -n "$last_line" ]; then
        last_line_marker=$(grep -n "$last_line" "$log_file" | cut -d: -f1)
    fi
else
    touch "$log_file"
fi

# 새로운 로그 데이터를 임시 파일에 저장
dmesg > "$temp_file"
journalctl -p err -n 50 >> "$temp_file"

# 중복된 부분을 건너뛴 후 남은 로그를 로그 파일에 추가
if [ -n "$last_line_marker" ]; then
    tail -n +"$last_line_marker" "$temp_file" >> "$log_file"
else
    cat "$temp_file" >> "$log_file"
fi

# 임시 파일 삭제
rm -f "$temp_file"
