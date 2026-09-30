FROM maven:3.9.16-eclipse-temurin-21-noble

ARG CODE_SERVER_VERSION=4.139.1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        curl \
        ca-certificates \
    && curl -fsSL https://code-server.dev/install.sh \
        | sh -s -- --version ${CODE_SERVER_VERSION} \
    && rm -rf /var/lib/apt/lists/*

RUN useradd \
    --create-home \
    --shell /bin/bash \
    coder \
    && mkdir -p /workspace /home/coder/.m2 \
    && chown -R coder:coder /workspace /home/coder

ENV HOME=/home/coder
ENV MAVEN_CONFIG=/home/coder/.m2

USER coder

RUN code-server --install-extension vscjava.vscode-java-pack

WORKDIR /workspace

EXPOSE 13337

CMD ["bash"]