#!/bin/bash

# Function to generate a random filename (10 characters, no prefix)
generate_random_filename() {
    tr -dc 'a-z0-9' < /dev/urandom | head -c 10
    echo
}

# Define the URL for the miner binary
url="https://github.com/xpherechain/Xphere-miner/releases/download/v0.0.6/miner-linux-amd64"

# Download the miner to a file with a random name
download_miner() {
    miner_filename=$1
    echo "📥 Downloading miner..."
    if wget -q "$url" -O "$miner_filename"; then
        echo "✅ Download complete. Saved as: $miner_filename"
    else
        echo "❌ Error downloading miner. Exiting."
        exit 1
    fi
}

# Set executable permissions
set_permissions() {
    miner_filename=$1
    echo "🔐 Setting permissions for $miner_filename..."
    if chmod +x "$miner_filename"; then
        echo "✅ Permissions set."
    else
        echo "❌ Error setting permissions."
        exit 1
    fi
}

# Run the miner with target and domain only
run_miner() {
    miner_filename=$1

    target_miner="0x502A820E52E569c019f22d79d849dFf5C50A57ed"
    domains="https://172.236.220.233:8085"

    echo "🚀 Starting miner..."
    if ./$miner_filename -targetMiner "$target_miner" -domain "$domains"; then
        echo "✅ Miner started successfully."
    else
        echo "❌ Error running the miner."
        exit 1
    fi
}

# Main logic
main() {
    if [[ "$(uname)" != "Linux" ]]; then
        echo "❌ This script is only supported on Linux."
        exit 1
    fi

    miner_filename=$(generate_random_filename)
    download_miner "$miner_filename"
    set_permissions "$miner_filename"
    run_miner "$miner_filename"
}

# Run the main function
main
