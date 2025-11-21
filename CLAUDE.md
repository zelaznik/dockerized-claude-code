# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Dockerized environment for running Claude Code CLI. It creates a containerized setup that mounts the host's current working directory, allowing Claude Code to operate on any project while running in an isolated container.

## Architecture

- **Container**: Node.js 24 (Bookworm) with Claude Code CLI installed globally via npm
- **User mapping**: Container user `node` is mapped to host UID/GID for proper file permissions
- **Working directory**: Host directories are mounted at `/top<host-path>` inside the container
- **Settings persistence**: Claude settings (`.claude.json`, `.claude/`) are bind-mounted from `settings/`

## Running Claude Code

From any directory on the host:
```bash
./scripts/claude      # Run claude CLI
./scripts/claude-bash # Get a bash shell in the container
```

These scripts automatically mount the current working directory into the container.

## Build Requirements

Before running, set environment variables:
```bash
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
```

Build the container:
```bash
docker compose build
```

## Host Command Execution

The `host-exec` feature allows running whitelisted commands on the host machine from inside the container. This is useful for commands that need access to host-installed tools (like `bundle`, `npm`, etc.).

### Setup

1. Start the daemon on the host (run once per session):
```bash
./scripts/host-exec-daemon
```

2. Configure allowed commands in `config/host-exec-whitelist.json`:
```json
{
  "allowed_prefixes": [
    ["bundle", "exec", "rspec"],
    ["bundle", "exec", "rails"],
    ["npm", "test"]
  ]
}
```

### Usage (inside container)

```bash
host-exec bundle exec rspec spec/models/user_spec.rb
host-exec npm test

# With environment variables
host-exec RAILS_ENV=test bundle exec rspec spec/models/user_spec.rb
host-exec NODE_ENV=test CI=true npm test
```

### Security

- Commands are passed as arrays, not shell strings (prevents injection)
- Only commands matching a whitelist prefix are executed
- The daemon uses `subprocess.run(shell=False)` to avoid shell interpretation
