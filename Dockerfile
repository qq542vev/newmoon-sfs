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
##   version - 1.0.0
##   created - 2026-02-01
##   modified - 2026-02-01
##   copyright - Copyright (C) 2026-2026 qq542vev. All rights reserved.
##   license - <GPL-3.0-only at https://www.gnu.org/licenses/gpl-3.0.txt>
##   conforms-to - <https://docs.docker.com/reference/dockerfile/>
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/newmoon-sfs>
##   * <Bag report at https://github.com/qq542vev/newmoon-sfs/issues>

FROM ubuntu:24.04 AS build

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 TZ=UTC0 DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-euo", "posix", "-o", "pipefail", "-c"]

RUN \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		ca-certificates curl jq make squashfs-tools xz-utils && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /work
COPY GNUmakefile .
COPY rootfs rootfs

ARG MAKE_OPTS=
RUN until make SHELL=/bin/bash ${MAKE_OPTS}; do :; done

FROM scratch

COPY --from=build /work/build /build
