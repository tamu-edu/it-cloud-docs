FROM alpine:latest

ARG MDBOOK_VERSION=0.5.3
ARG ADMONISH_VERSION=1.20.0
ARG MERMAID_VERSION=0.17.0

RUN apk add cargo --no-cache
RUN cargo install mdbook@${MDBOOK_VERSION}
RUN cargo install mdbook-admonish@${ADMONISH_VERSION}
RUN cargo install mdbook-mermaid@${MERMAID_VERSION}

ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /project
ENTRYPOINT ["mdbook"]