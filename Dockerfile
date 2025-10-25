ARG NODE_VERSION=24
FROM docker.io/library/node:$NODE_VERSION-bookworm

ARG UID
ARG GID

# Environment variables
ENV NODE_PATH="/top/node_modules"
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

RUN npm install -g @anthropic-ai/claude-code@2.0.27

USER node

COPY --chown=node:node package*.json .

RUN npm install

COPY --chown=node:node . .

