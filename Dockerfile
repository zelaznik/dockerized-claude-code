FROM ubuntu:latest

ARG UID=1000
ARG GID=1000

# Environment variables
WORKDIR /top

# System dependencies
RUN apt-get update && \
    apt-get install -y \
        bash \
        curl \
        git \
        jq \
        less \
        lsof \
        vim \
    && rm -rf /var/lib/apt/lists/*

# Match container user to host UID/GID (only if different from current)
RUN if [ "$(id -g ubuntu)" != "${GID}" ]; then groupmod -g ${GID} ubuntu; fi && \
    if [ "$(id -u ubuntu)" != "${UID}" ]; then usermod -u ${UID} -g ${GID} ubuntu; fi
RUN chown -R ubuntu:ubuntu /top

USER ubuntu

RUN curl -fsSL https://claude.ai/install.sh | bash

# Set PATH as environment variable so it's available to all processes (not just interactive shells)
ENV PATH="/home/ubuntu/.local/bin:$PATH"
# Create .claude directory so volume inherits correct ownership
RUN mkdir -p /home/ubuntu/.claude

COPY --chown=ubuntu:ubuntu . .
COPY --chown=ubuntu:ubuntu entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
