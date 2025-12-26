#!/bin/bash
set -e

# Create config.json with valid empty JSON if it doesn't exist
if [ ! -f /home/ubuntu/.claude/config.json ]; then
    echo '{}' > /home/ubuntu/.claude/config.json
fi

# Ensure .claude.json is a symlink to the persisted volume location
# Remove it if it exists but is not a symlink
if [ -e /home/ubuntu/.claude.json ] && [ ! -L /home/ubuntu/.claude.json ]; then
    # If it's a regular file, merge its contents with config.json before removing
    if [ -f /home/ubuntu/.claude.json ] && [ -f /home/ubuntu/.claude/config.json ]; then
        # Backup the non-persisted file and use it if config.json is empty/minimal
        if [ "$(stat -c%s /home/ubuntu/.claude/config.json)" -lt "$(stat -c%s /home/ubuntu/.claude.json)" ]; then
            mv /home/ubuntu/.claude.json /home/ubuntu/.claude/config.json
        else
            rm /home/ubuntu/.claude.json
        fi
    else
        rm -f /home/ubuntu/.claude.json
    fi
fi

# Create symlink if it doesn't exist
if [ ! -e /home/ubuntu/.claude.json ]; then
    ln -s /home/ubuntu/.claude/config.json /home/ubuntu/.claude.json
fi

exec "$@"
