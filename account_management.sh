#!/bin/bash


function create_account() {
    username="$1"
    password="$2"

    if id "$username" &>/dev/null; then
        echo "User $username already exists!"
        return 1
    fi

    sudo useradd "$username"
    echo "$password" | sudo passwd --stdin "$username"
    echo "User $username created successfully!"
}

function delete_account() {
    username="$1"

    if ! id "$username" &>/dev/null; then
        echo "User $username doesn't exist!"
        return 1
    fi

    sudo userdel -r "$username"
    echo "User $username deleted successfully!"
}

function disable_account() {
    username="$1"

    if ! id "$username" &>/dev/null; then
        echo "User $username doesn't exist!"
        return 1
    fi

    sudo passwd -l "$username"
    echo "User $username disabled successfully!"
}

# Main script 
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 {create|delete|disable} username [password_for_new_user]"
    exit 1
fi

action="$1"
username="$2"
password="$3"

case "$action" in
    create)
        if [ -z "$password" ]; then
            echo "Please provide a password for the new user."
            exit 1
        fi
        create_account "$username" "$password"
        ;;
    delete)
        delete_account "$username"
        ;;
    disable)
        disable_account "$username"
        ;;
    *)
        echo "Invalid action: $action"
        echo "Usage: $0 {create|delete|disable} username [password_for_new_user]"
        exit 1
        ;;
esac

