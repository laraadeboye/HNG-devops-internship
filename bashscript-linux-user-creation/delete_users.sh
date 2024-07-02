#!/usr/bin/bash

# Function to log messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root or with sudo privileges" >&2
    log "Script not run as root or with sudo privileges"
    exit 1
fi

# File paths
USER_FILE="$1"
LOG_FILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.txt"

# Check if a file name is provided as an argument
if [ -z "$USER_FILE" ]; then
    echo "Usage: $0 <name-of-text-file>"
    exit 1
fi

# Check if the input file exists
if [ ! -f "$USER_FILE" ]; then
    echo "Input file not found"
    exit 1
fi

# Read the user file line by line
while IFS=';' read -r username groups; do
    # Trim whitespace from username
    username=$(echo "$username" | xargs)

    # Check if the username is not empty
    if [ -z "$username" ]; then
        log "Invalid line format in user file: '$username;$groups'"
        continue
    fi

    # Check if the user exists
    if id "$username" &>/dev/null; then
        # Delete the user and their home directory
        userdel -r "$username"
        if [ $? -eq 0 ]; then
            log "User $username and their home directory deleted."
        else
            log "Failed to delete user $username."
            continue
        fi
    else
        log "User $username does not exist."
    fi

    # Delete the personal group for the user if it exists
    if getent group "$username" > /dev/null; then
        groupdel "$username"
        if [ $? -eq 0 ]; then
            log "Group $username deleted."
        else
            log "Failed to delete group $username."
        fi
    fi

    # Delete additional groups if they exist and if they have no members
    IFS=',' read -ra group_list <<< "$groups"
    for group in "${group_list[@]}"; do
        if getent group "$group" > /dev/null; then
            # Check if the group has any members left
            if [ "$(getent group "$group" | awk -F: '{print $4}')" == "" ]; then
                groupdel "$group"
                if [ $? -eq 0 ]; then
                    log "Group $group deleted."
                else
                    log "Failed to delete group $group."
                fi
            else
                log "Group $group not deleted, as it has other members."
            fi
        fi
    done
    unset IFS

done < "$USER_FILE"

# Delete the password file
if [ -f "$PASSWORD_FILE" ]; then
    rm -f "$PASSWORD_FILE"
    if [ $? -eq 0 ]; then
        log "Password file $PASSWORD_FILE deleted."
    else
        log "Failed to delete password file $PASSWORD_FILE."
    fi
fi

# Delete the log file
if [ -f "$LOG_FILE" ]; then
    rm -f "$LOG_FILE"
    if [ $? -eq 0 ]; then
        log "Log file $LOG_FILE deleted."
    else
        log "Failed to delete log file $LOG_FILE."
    fi
fi

# End of script
log "User deletion script completed."
echo "$(date '+%Y-%m-%d %H:%M:%S') - User deletion script completed."
exit 0