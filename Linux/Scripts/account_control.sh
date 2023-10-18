#!/bin/bash

# Declares the files from command line
ACCOUNT_CREATE="$1"
ACCOUNT_DELETE="$2"
ACCOUNT_DISABLE="$3"

create_user()
{
    # Creates users from file with a password
    local username="$1"
    local password="$2"

    if id "$username" &>/dev/null; then
        echo "User '$username' already exists."
    else
        sudo useradd -p "$password" "$username" 
        echo "User $username created"
    fi 
}

delete_user()
{
    # Deletes users from the file
    local username="$1"

    if id "$username" &>/dev/null; then
        sudo userdel -r "$username"
        echo "User $username deleted"
    else
        echo "User $username does not exist"
    fi
}

disable_user()
{
    # Disables the user
    local username="$1"

    if id "$username" &>/dev/null; then
        sudo usermod -L "$username"
        echo "User $username disabled"
    else
        echo "User $username does not exist"
    fi
}

main()
{
    # Reads from the input files
    if [ -n $ACCOUNT_CREATE ]; then
        while IFS=':' read -r user password; do
            create_user "$user" "$password"
        done < "$ACCOUNT_CREATE"
    fi

    if [ -n $ACCOUNT_DELETE ]; then
        while IFS= read -r username; do
            delete_user "$username"
        done < "$ACCOUNT_DELETE"
    fi

    if [ -n $ACCOUNT_DISABLE ]; then
        while IFS= read -r user_name; do
            disable_user "$user_name"
        done < "$ACCOUNT_DISABLE"
    fi

    echo "Finished"
}

main