#!/bin/bash
set -e

# Create config.json with valid empty JSON if it doesn't exist
if [ ! -f /home/node/.claude/config.json ]; then
    echo '{}' > /home/node/.claude/config.json
fi

# Create symlink so .claude.json lives inside the persisted volume
if [ ! -e /home/node/.claude.json ]; then
    ln -s /home/node/.claude/config.json /home/node/.claude.json
fi

exec "$@"
