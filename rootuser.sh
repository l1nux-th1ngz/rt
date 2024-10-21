#!/bin/bash

apt-get -y install sudo

# Prompt for username if not provided
read -p "Enter the username to add to root privileges: " username

# Check if user exists
if id "$username" &>/dev/null; then
    echo "User $username exists, proceeding with granting root privileges..."
else
    echo "User $username does not exist. Please create the user first."
    exit 1
fi

# 1. Add user to sudo group
echo "Adding $username to sudo group..."
sudo usermod -aG sudo "$username"

# 2. Add user to root group (optional, not recommended)
echo "Adding $username to root group..."
sudo usermod -aG root "$username"

# 3. Edit /etc/sudoers to give full sudo privileges (skipping manual visudo for now)
# Automatically appending to sudoers file (but using a safe custom file)
SUDOERS_FILE="/etc/sudoers.d/$username"
echo "Adding $username to sudoers file with full privileges..."
if [ ! -f "$SUDOERS_FILE" ]; then
    sudo bash -c "echo '$username ALL=(ALL:ALL) ALL' > $SUDOERS_FILE"
    sudo chmod 440 "$SUDOERS_FILE"
else
    echo "Sudoers file for $username already exists."
fi

# 4. Inform user about manual visudo editing (for advanced privileges)
echo "If you want to make further edits, please use 'sudo visudo' and manually add the following line:"
echo "$username ALL=(ALL:ALL) ALL"
echo "Otherwise, the user has been granted full sudo privileges via /etc/sudoers.d/$username."

# Final message
echo "User $username has been granted root privileges using sudo, root group, and sudoers file."
