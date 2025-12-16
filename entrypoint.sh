#!/bin/bash
set -e

# Ensure .claude directory exists in the volume
mkdir -p /home/node/.claude

# Create symlink for .claude.json to live inside the .claude directory
# This way everything persists in the single mounted volume
if [ ! -e /home/node/.claude.json ]; then
    ln -s /home/node/.claude/config.json /home/node/.claude.json
fi

exec "$@"
