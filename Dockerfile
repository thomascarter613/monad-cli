FROM rust:1-bookworm AS build
WORKDIR /workspace
COPY . .
RUN cargo build --workspace --release

FROM debian:bookworm-slim
COPY --from=build /workspace/target/release/monad /usr/local/bin/monad
ENTRYPOINT ["monad"]
