#!/bin/bash

message_count() {
	grep -i "$1" "$2" | wc -l
}

error_count=$(message_count "ERROR" "$1")
echo "ERROR Messages: $error_count"


warning_count=$(message_count "WARNING" "$1")
echo "WARNING Messages: $warning_count"

info_count=$(message_count "INFO" "$1")
echo "INFO Messages: $info_count"

top_errors() {
	grep -i "ERROR" "$1" | sort | uniq -c | sort -nr | head -3
}








