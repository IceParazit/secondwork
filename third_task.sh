#!/bin/bash

backup_dir="/back/up/dir"
source_dir="/source/dir"
log_file="/dir/for/back/log"
error_log="/dir/for/fail/log"
email="test@mail.com"


send_email() {
    echo "$1" | mail -s "Backup Status" "$email"
}


backup() {
    rsync -aH --link-dest="$backup_dir/latest" "$source_dir" "$backup_dir/incremental_backup_$(date +%Y-%m-%d)"
    cp -al "$backup_dir/incremental_backup_$(date +%Y-%m-%d)" "$backup_dir/latest"
}


if [ "$(date +%u)" -eq 7 ]; then
    rsync -aH --delete "$source_dir" "$backup_dir/full_backup_$(date +%Y-%m-%d)" || { echo "$(date): Backup failed" >> "$error_log"; send_email "Backup failed. Check error log for details."; exit 1; }
else
    backup || { echo "$(date): Backup failed" >> "$error_log"; send_email "Backup failed. Check error log for details."; exit 1; }
fi


find "$log_file" -type f -mtime +7 -delete


echo "$(date): Backup completed" >> "$log_file"


send_email "Backup completed successfully."
