### File: Dockerfile
##
## New Moon SFSを組み立てる。
##
## Usage:
##
## ------ Text ------
## docker buildx build -f Dockerfile
## ------------------
##
## Build arg:
##
##   MAKE_OPTS - makeコマンドへのオプション。
##
## Metadata:
##
##   id - 310cbe06-7573-4a6e-a9d8-8c915fd76a81
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 1.0.1
##   created - 2026-02-01
##   modified - 2026-08-18
##   copyright - Copyright (C) 2026-2026 qq542vev. All rights reserved.
##   license - <GPL-3.0-only at https://www.gnu.org/licenses/gpl-3.0.txt>
##   conforms-to - <https://docs.docker.com/reference/dockerfile/>
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/newmoon-sfs>
##   * <Bug report at https://github.com/qq542vev/newmoon-sfs/issues>

ARG IMAGE=ubuntu:26.04
FROM ${IMAGE} AS build

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 TZ=UTC0 DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/sh", "-euo", "pipefail", "-c"]

RUN \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		ca-certificates curl jq make squashfs-tools xz-utils && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /work
COPY GNUmakefile .
COPY root root

ARG MAKE_OPTS=
RUN make ${MAKE_OPTS}

FROM scratch

COPY --from=build /work/build /build
