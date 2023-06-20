#!/bin/bash

# Function to count the number of lines in text files belonging to a specific owner
count_lines_by_owner() {
    local owner="$1"
    local count=0
    
    while IFS= read -r file; do
        if [ -f "$file" ] && [ "$(stat -c '%U' "$file")" = "$owner" ]; then
            lines=$(wc -l < "$file")
            count=$((count + lines))
        fi
    done < <(find . -maxdepth 1 -type f -name "*.txt")
    
    echo "Total lines in files owned by $owner: $count"
}

# Function to count the number of lines in text files created in a specific month
count_lines_by_month() {
    local month="$1"
    local count=0
    
    while IFS= read -r file; do
        if [ -f "$file" ] && [ "$(date -r "$file" "+%m")" = "$month" ]; then
            lines=$(wc -l < "$file")
            count=$((count + lines))
        fi
    done < <(find . -maxdepth 1 -type f -name "*.txt")
    
    echo "Total lines in files created in month $month: $count"
}

# Function to display help message
show_help() {
    echo "Usage: $0 [-o <owner>] [-m <month>]"
    echo "Options:"
    echo "  -o <owner>  : Count lines in files belonging to <owner>"
    echo "  -m <month>  : Count lines in files created in <month>"
    echo "  -h          : Show this help message"
}

# Parse command-line arguments
while getopts "o:m:h" option; do
    case $option in
        o)
            owner="$OPTARG"
            count_lines_by_owner "$owner"
            exit 0
            ;;
        m)
            month="$OPTARG"
            count_lines_by_month "$month"
            exit 0
            ;;
        h)
            show_help
            exit 0
            ;;
        *)
            show_help
            exit 1
            ;;
    esac
done

# If no valid options are provided, show help
show_help
exit 1
