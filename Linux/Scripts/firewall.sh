#!/bin/bash

# Function to print UFW rules
print_rules() {
    echo "UFW Firewall Rules:"
    ufw status verbose
}

# Function to add a rule
add_rule() {
    echo "Adding a new UFW rule:"
    read -p "Enter rule (e.g., 'allow 22/tcp'): " rule
    ufw allow $rule
    echo "Rule added: $rule"
}

# Function to remove a rule
remove_rule() {
    echo "Removing a UFW rule:"
    read -p "Enter rule to remove (e.g., 'allow 22/tcp'): " rule
    ufw delete allow $rule
    echo "Rule removed: $rule"
}

# Function to backup UFW rules
backup_rules() {
    echo "Backing up UFW rules to 'ufw_backup'"
    mkdir ./ufw_backup/
    cp /etc/ufw/user.rules ./ufw_backup/user.rules
    cp /etc/ufw/user6.rules ./ufw_backup/user6.rules
    echo "Backup complete."
}

# This function will enable UFW if not running, and will disable it if running
switch_ufw() {
    if ufw status | grep -q "Status: active"; then
        ufw disable
        echo "UFW is now disabled"
    elif ufw status | grep -q "Status: inactive"; then
        ufw enable
        echo "UFW is now enabled"
    else
        echo "Error"
    fi
}

# Main menu
if [ $EUID != 0 ]; then
    echo "This script must be ran as superuser (use sudo)"
    exit 1
fi

while true; do
    echo -n "UFW "
    ufw status
    if [ $? -ne 0 ]; then
        echo "UFW is not installed. Please install UFW."
        exit 1
    fi
    echo "1. Enable/Disable UFW"
    echo "2. Print UFW Rules"
    echo "3. Add Rule"
    echo "4. Remove Rule"
    echo "5. Backup Rules"
    echo "6. Exit"
    
    read -p "Select an option (1/2/3/4/5/6): " choice
    
    case $choice in
        1) switch_ufw;;
        2) print_rules;;
        3) add_rule;;
        4) remove_rule;;
        5) backup_rules;;
        6) exit;;
        *) echo "Invalid option. Please select a valid option.";;
    esac
done
