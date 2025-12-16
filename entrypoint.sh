#!/bin/bash
set -e

# Create symlink so .claude.json lives inside the persisted volume
if [ ! -e /home/node/.claude.json ]; then
    ln -s /home/node/.claude/config.json /home/node/.claude.json
fi

exec "$@"
