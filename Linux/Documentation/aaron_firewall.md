# Functions

Enable/Disable UFW – This function is self-explanatory; it will simply enable UFW if it is disabled and disable it if enabled.
Print UFW Rules – Just an alias for `ufw status numbered`
Add Rule – Adds a UFW rule, needs to be added in the format <allow/deny> <port>/<protocol>
Remove Rule – Removes a UFW rule, can either be the rule number or the format from Add rule
Backup Rules – This will copy the rule files from /etc/ufw, and copy them into the directory that the script is running in.

This script needs to be ran as sudo, and needs UFW installed.