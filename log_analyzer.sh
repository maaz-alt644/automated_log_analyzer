#!/bin/bash
FILE_LOG="/home/maaz/project/automated-log-analyzer/log_report.txt"
echo "====================" > "$FILE_LOG"
echo "    LOG ANALYZER" >> "$FILE_LOG"
echo "====================" >> "$FILE_LOG"
echo
HOST_NAME=$(hostname)
echo "Hostname: $HOST_NAME" >> "$FILE_LOG"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
echo "Date: $TIMESTAMP" >> "$FILE_LOG"
echo "Date: $DATE" >> "$FILE_LOG"
echo

if [ -z "$1" ]; then
	echo "Usage: $0 <log_file>"
	exit 1
fi

FAILED_THRESHOLD=5

if [ -f "$1" ]; then
	echo "File exists"
elif [ -d "$1" ]; then
	echo "Folder '$1' exists"
	exit 1
else 
	echo "$1 doesnt exists"
	exit 1
fi

count_line=$(wc -l "$1" | awk '{print $1}')
echo "Total lines: $count_line" >> "$FILE_LOG"

message_count() {
	grep -i "$1" "$2" | wc -l
}

	error_count=$(message_count "ERROR" "$1")
	echo "Error Messages: $error_count" >> "$FILE_LOG"
	
	warning_count=$(message_count "WARNING" "$1")
	echo "Warning Messages: $warning_count" >> "$FILE_LOG"

	info_count=$(message_count "INFO" "$1")
	echo "Info Messages: $info_count" >> "$FILE_LOG"

top_error() {
	grep -i "ERROR" "$1" | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -nr | head -3
}
echo

failed_login() {
	grep -i "Failed password" "$1" | wc -l
}
echo "Failed login attempts: $(failed_login "$1")" >> "$FILE_LOG"

failed_attempts=$(failed_login "$1")
if [ "$failed_attempts" -ge "$FAILED_THRESHOLD" ]; then
	echo "Staus: Suspicious" >> "$FILE_LOG"
else
	echo "Status: Normal" >> "$FILE_LOG"
fi

if [ "$failed_attempts" -ge "$FAILED_THRESHOLD" ]; then
    ANALYSIS_STATUS="SUSPICIOUS"
else
    ANALYSIS_STATUS="NORMAL"
fi
echo "ANALYSIS STATUS: $ANALYSIS_STATUS" >> "$FILE_LOG"

if [ "$ANALYSIS_STATUS" = "SUSPICIOUS" ]; then
	exit 1
else
	exit 0
fi

echo "Top 3 Errors: " >> "$FILE_LOG"
top_error "$1" >> "$FILE_LOG"

echo "Analyzing: "$1""

echo "Analysis completed successfully."

echo "Report saved to: "$FILE_LOG""

