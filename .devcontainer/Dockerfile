FROM alpine:latest AS stage

RUN wget https://github.com/rust-lang/mdBook/releases/download/v0.4.37/mdbook-v0.4.37-aarch64-unknown-linux-musl.tar.gz
RUN tar -xvf mdbook-v0.4.37-aarch64-unknown-linux-musl.tar.gz

RUN wget https://github.com/tommilligan/mdbook-admonish/releases/download/v1.15.0/mdbook-admonish-v1.15.0-x86_64-unknown-linux-musl.tar.gz
RUN tar -xvf mdbook-admonish-v1.15.0-x86_64-unknown-linux-musl.tar.gz

FROM alpine:latest
COPY --from=stage mdbook /usr/local/bin/mdbook
COPY --from=stage mdbook-admonish /usr/local/bin/mdbook-admonish
WORKDIR /project
ENTRYPOINT ["mdbook"]