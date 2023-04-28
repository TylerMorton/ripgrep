# Build Stage
FROM ghcr.io/evanrichter/cargo-fuzz:latest as builder

## Add source code to the build stage.
ADD . /build
WORKDIR /build

RUN echo building instrumented harnesses && \
    bash -c "cargo +nightly -Z sparse-registry fuzz build" && \
    mv fuzz/target/x86_64-unknown-linux-gnu/release/search_reader /search_reader && \
    echo done

# RUN echo building instrumented harnesses && \
#     bash -c "pushd ../fuzz && cargo +nightly -Z sparse-registry fuzz build" && \
#     mv fuzz/target/x86_64-unknown-linux-gnu/release/search_reader /search_reader && \
#     echo done

# # RUN echo building non-instrumented harnesses && \
# #     export RUSTFLAGS="--cfg fuzzing -Clink-dead-code -Cdebug-assertions -C codegen-units=1" && \
# #     bash -c "pushd crates/nu-parser/fuzz && cargo +nightly -Z sparse-registry build --release && popd" && \
# #     mv crates/nu-parser/fuzz/target/release/search_reader /search_reader_no_inst && \
# #     # mv crates/nu-parser/fuzz/target/release/lite_parser /lite_parser_no_inst && \
# #     echo done

# # Package Stage
# FROM rustlang/rust:nightly

# COPY --from=builder /search_reader /search_reader_no_inst /
# # COPY --from=builder /lite_parser /lite_parser_no_inst /