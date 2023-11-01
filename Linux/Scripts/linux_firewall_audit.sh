#!/bin/bash

# Author: Tim Koehler
# Bash script for managing UFW rules, backing up files, and restoring files from a backup

# Creates a backup of iptables
function backup_iptables() {
	iptables-save > iptables_bak
	echo "iptables backup created in" $(pwd)
}

# Restores iptables from a backup
# Ensure that a backup was already created prior to using this
function restore_iptables() {
	iptables-restore < iptables_bak
	echo "iptables successfully restored"
}

# Creates a backup of all necessary ufw files
function backup_ufw() {	
	cp /etc/default/ufw default_ufw_bak
	cp /etc/ufw/user.rules user_rules_bak
	cp /etc/ufw/user6.rules user6_rules_bak
	cp /lib/ufw/ufw-init ufw-init_bak
	echo "UFW backup created in" $(pwd)
}

# Restores ufw files from backups
function restore_ufw() {
	cp default_ufw_bak /etc/default/ufw
	cp user_rules_bak /etc/ufw/user.rules
	cp user6_rules_bak /etc/ufw/user6.rules
	cp ufw-init_bak /lib/ufw/ufw-init
	echo "UFW successfully restored"
}

# Show existing ufw rules
function view_existing_rules() {
	ufw status numbered
}

# Set existing rule to allow
function allow_ufw_port() {
	view_existing_rules
	read -p "Enter the port number to allow: " port
	ufw allow $port
}

# Set existing rule to deny
function deny_ufw_port() {
	view_existing_rules
	read -p "Enter the port number to deny: " port
	ufw deny $port
}

# Delete existing rule
function delete_ufw_rule() {
	view_existing_rules
	read -p "Enter the number of the rule to delete: " rule
	ufw delete $rule
}

# Check that the script is ran using sudo
if [ $EUID != 0 ]; then
	echo "This script must be run with sudo"
	exit 1
fi

# Main loop - display a menu to the user
while :
do
	echo "UFW Tool Script"
	echo "---------------"
	echo "1. Audit firewall rules in UFW"
	echo "2. Allow a port in UFW"
	echo "3. Deny a port in UFW"
	echo "4. Delete an existing UFW rule"
	echo "5. Backup UFW"
	echo "6. Restore UFW from an existing backup"
	echo "7. Backup iptables"
	echo "8. Restore iptables from an existing backup"
	echo "-1. Quit"

	read -p "Choose an option (type -1 to quit): " choice

	clear

	if [ $choice == 1 ]; then
		view_existing_rules
	elif [ $choice == 2 ]; then
		allow_ufw_port
	elif [ $choice == 3 ]; then
		deny_ufw_port
	elif [ $choice == 4 ]; then
		delete_ufw_rule
	elif [ $choice == 5 ]; then
		backup_ufw
	elif [ $choice == 6 ]; then
		restore_ufw
	elif [ $choice == 7 ]; then
		backup_iptables
	elif [ $choice == 8 ]; then
		restore_iptables
	elif [ $choice == -1 ]; then
		break
	else
		echo "Please enter a number from 1 to 8, or -1 to quit"
	fi

	echo ""
	echo ""
done
