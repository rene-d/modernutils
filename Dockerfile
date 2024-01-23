ARG BUILDER=rust:1-buster
ARG BASETEST=debian:buster



#
# modernutils
#
FROM ${BUILDER} AS builder

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y cmake

# lolcat-c
RUN curl -skL \
    -O https://raw.githubusercontent.com/jaseg/lolcat/main/xterm256lut.h \
    -O https://raw.githubusercontent.com/jaseg/lolcat/main/lolcat.c && \
    cc -O2 -o /usr/local/bin/lolcat -static -std=c99 lolcat.c -lm && \
    strip /usr/local/bin/lolcat

# Tools written in Rust
RUN cargo install --root /usr/local ripgrep
RUN cargo install --root /usr/local watchexec-cli
RUN cargo install --root /usr/local bottom
RUN cargo install --root /usr/local dua-cli
RUN cargo install --root /usr/local bat
RUN cargo install --root /usr/local lsd
RUN cargo install --root /usr/local xsv
RUN cargo install --root /usr/local hexyl
RUN cargo install --root /usr/local hyperfine
RUN cargo install --root /usr/local starship
RUN cargo install --root /usr/local atuin
RUN cargo install --root /usr/local hx

RUN strip /usr/local/bin/*

#
# Test suite
#
FROM ${BASETEST} AS test

ARG BASETEST
ENV BASETEST ${BASETEST}
ENV PATH /some/where/bin:$PATH
COPY --from=builder --chown=0:0 /usr/local/bin/ /some/where/bin/
RUN set -e; \
    for i in /some/where/bin/*; do \
        p=$(basename $i); \
        o="--version"; \
        printf "%s \033[96m${BASETEST}\033[0m: \033[92m%-10s\033[0m: \033[0m%s\033[0m\n" "@" $p "$($p $o | tr '\n' ' ')"; \
    done && \
    echo DONE


#
# Package binaries into a bare image
#
FROM scratch

COPY --from=builder --chown=0:0 /usr/local/bin/ /bin/
COPY README.md /
