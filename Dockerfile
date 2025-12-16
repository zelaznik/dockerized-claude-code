ARG NODE_VERSION=24
FROM docker.io/library/node:$NODE_VERSION-bookworm

ARG UID=1000
ARG GID=1000

# Environment variables
WORKDIR /top

# System dependencies
RUN apt-get update && \
    apt-get install -y \
        jq \
        less \
        lsof \
        vim \
    && rm -rf /var/lib/apt/lists/*

# Match container user to host UID/GID (only if different from current)
RUN if [ "$(id -g node)" != "${GID}" ]; then groupmod -g ${GID} node; fi && \
    if [ "$(id -u node)" != "${UID}" ]; then usermod -u ${UID} -g ${GID} node; fi
RUN chown -R node:node /top

RUN npm install -g @anthropic-ai/claude-code

COPY --chown=node:node entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER node

COPY --chown=node:node . .

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
