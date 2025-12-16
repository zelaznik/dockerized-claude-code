ARG NODE_VERSION=24
FROM docker.io/library/node:$NODE_VERSION-bookworm

ARG UID
ARG GID

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

# Match container user to host UID/GID
RUN groupmod -g ${GID:?required} node && usermod -u ${UID:?required} -g ${GID:?required} node
RUN chown -R node:node /top

RUN npm install -g @anthropic-ai/claude-code

COPY --chown=node:node entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER node

COPY --chown=node:node . .

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
