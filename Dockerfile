ARG BUILDER=centos7
ARG BASETEST=centos:7


#
# Base: Debian Bullseye
#
FROM rust:1-bullseye AS bullseye


#
# Base: CentOS 7
#
FROM centos:7 AS centos7

RUN yum -y update
RUN yum -y install gcc openssl openssl-devel perl

RUN localedef -i en_US -f UTF-8 en_US.UTF-8

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o /tmp/rustup.sh && \
    sh /tmp/rustup.sh -y && \
    rm /tmp/rustup.sh

ENV PATH /root/.cargo/bin:$PATH


#
# modernutils
#
FROM ${BUILDER} AS builder

# Tools written in Rust
RUN cargo install --root /usr/local ripgrep
RUN cargo install --root /usr/local watchexec-cli
RUN cargo install --root /usr/local bottom
RUN cargo install --root /usr/local dua-cli
RUN cargo install --root /usr/local bat
RUN cargo install --root /usr/local lsd
RUN cargo install --root /usr/local gitui
RUN cargo install --root /usr/local lscolors
RUN cargo install --root /usr/local fd-find
RUN cargo install --root /usr/local xsv
RUN cargo install --root /usr/local hexyl
RUN cargo install --root /usr/local broot

RUN strip /usr/local/bin/*

# Prebuilt Go binaries
RUN curl -skL https://github.com/wagoodman/dive/releases/download/v0.10.0/dive_0.10.0_linux_amd64.tar.gz | tar -C /usr/local/bin --owner 0 --group 0 -xz dive
RUN curl -skL https://github.com/junegunn/fzf/releases/download/0.29.0/fzf-0.29.0-linux_amd64.tar.gz | tar -C /usr/local/bin --owner 0 --group 0 -xz fzf
RUN curl -skL https://github.com/jesseduffield/lazygit/releases/download/v0.32.2/lazygit_0.32.2_Linux_x86_64.tar.gz | tar -C /usr/local/bin --owner 0 --group 0 -xz lazygit

# Prebuilt C binaries
RUN curl -skL https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o /usr/local/bin/jq && chmod +x /usr/local/bin/jq

# Build other C binaries
FROM alpine:edge AS tmux-builder

WORKDIR /build

# tmux
RUN apk update && apk add --no-cache gcc musl-dev libevent-static libevent-dev ncurses-static ncurses-dev make curl && \
    curl -skL https://github.com/tmux/tmux/releases/download/3.2a/tmux-3.2a.tar.gz | tar -xz && \
    cd tmux-3.2a && \
    ./configure --prefix=/usr/local --enable-static && \
    make -j && \
    make install

# lolcat-c
RUN curl -skL https://raw.githubusercontent.com/jaseg/lolcat/main/lolcat.c | \
    cc -o /usr/local/bin/lolcat -static -std=c99 -x c - -lm && \
    strip /usr/local/bin/lolcat

#
# Test suite
#
FROM ${BASETEST} AS test

ARG BASETEST
ARG RANDOM 0
ENV BASETEST ${BASETEST}
ENV PATH /some/where/bin:$PATH
COPY --from=builder --chown=0:0 /usr/local/bin/ /some/where/bin/
COPY --from=tmux-builder --chown=0:0 /usr/local/bin/ /some/where/bin/
RUN set -e; \
    for i in /some/where/bin/*; do \
    p=$(basename $i); \
    [ $p = lscolors ] && continue; \
    o="--version"; \
    [ $p = tmux ] && o="-V"; \
    printf "%s \033[96m${BASETEST}\033[0m: \033[92m%-10s\033[0m: \033[0m%s\033[0m\n" "@" $p "$($p $o | tr '\n' ' ')"; \
    done


#
# Package binaries into a bare image
#
FROM scratch

COPY --from=builder --chown=0:0 /usr/local/bin/ /
COPY --from=tmux-builder --chown=0:0 /usr/local/bin/ /
COPY README.md /
