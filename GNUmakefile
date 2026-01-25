#!/usr/bin/make -f

### Script: GNUmakefile
##
## ファイルを作成する。
##
## Metadata:
##
##   id - 0f626fa2-2e49-42b0-8351-f44bd6ab4c34
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 1.0.0
##   created - 2026-01-22
##   modified - 2026-01-22
##   copyright - Copyright (C) 2026-2026 qq542vev. All rights reserved.
##   license - <GPL-3.0-only at https://www.gnu.org/licenses/gpl-3.0.txt>
##   depends - docker, find, git, glab, mkdir, mv, rm, tar, test
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/build-mozjpeg>
##   * <Bag report at https://github.com/qq542vev/build-mozjpeg/issues>

# Sp Targets
# ==========

.PHONY: all newmoon/all newmoon-sse/all newmoon-ia32/all clean rebuild update publish unpublish image help version

.SILENT: help version

# Macro
# =====

VERSION = 1.0.0

CURL = curl -fLsS
FILES = jq -r '.files[] | select(.name | test("newmoon*\\.tar\\.xz$$")) | .name' '$(<)'
NEWMOON_DL = https://archive.org/download/centos7newmoon-32.0.0.linux-i686-gtk2.tar/
NEWMOONSSE_DL = https://archive.org/metadata/debian9newmoonsse-31.4.2.linux-i686-gtk2.tar
NEWMOONIA32_DL = https://archive.org/download/debian9newmoonia32-31.4.2.linux-i686-gtk2.tar

EXPAND = \
	dir=$$(mktemp -d) && \
	trap 'rm -rf -- "$${dir}"' EXIT && \
	cp -R -- rootfs/* "$${dir}" && \
	tar -C "$${dir}/usr/lib" -xJvf '$(<)'
MKSQUASHFS_OPTS = -all-root -no-xattrs
XZSFS = $(EXPAND) && mksquashfs "$${dir}" '$(@)'-b 1MB -comp xz -Xbcj x86 -Xdict-size 100% $(MKSQUASHFS_OPTS)
ZSTDSFS = $(EXPAND) && mksquashfs "$${dir}" '$(@)' -b 128KB -comp zstd -Xcompression-level 19 $(MKSQUASHFS_OPTS)

# Build Targets
# =============

all: newmoon/all newmoon-sse/all newmoon-ia32/all

newmoon/all: newmoon.json
	$(MAKE) $(FILES:%.tar.xz=newmoon/%.xz.sfs) $(FILES:%.tar.xz=newmoon/%.zstd.sfs)

newmoon.json:
	$(CURL) -o '$(@)' 'https://archive.org/metadata/centos7newmoon-32.0.0.linux-i686-gtk2.tar'

newmoon/%.xz.sfs: newmoon/%.tar.xz
	$(XZSFS)

newmoon/%.zstd.sfs: newmoon/%.tar.xz
	$(ZSTDSFS)

newmoon/%.tar.xz:
	mkdir -p -- '$(@D)'
	$(CURL) -o '$(@)' '$(NEWMOON_DL)$(@F)'

newmoon-sse/all: newmoon-sse.json
	$(MAKE) $(FILES:%.tar.xz=newmoon-sse/%.xz.sfs) $(FILES:%.tar.xz=newmoon-sse/%.zstd.sfs)

newmoon-sse.json:
	$(CURL) -o '$(@)' 'https://archive.org/metadata/debian9newmoonsse-31.4.2.linux-i686-gtk2.tar'

newmoon-sse/%.xz.sfs: newmoon-sse/%.tar.xz
	$(XZSFS)

newmoon-sse/%.zstd.sfs: newmoon-sse/%.tar.xz
	$(ZSTDSFS)

newmoon-sse/%.tar.xz:
	mkdir -p -- '$(@D)'
	$(CURL) -o '$(@)' '$(NEWMOONSSE_DL)$(@F)'

newmoon-ia32/all: newmoon-ia32.json
	$(MAKE) $(FILES:%.tar.xz=newmoon-ia32/%.xz.sfs) $(FILES:%.tar.xz=newmoon-ia32/%.zstd.sfs)

newmoon-ia32.json:
	$(CURL) -o '$(@)' 'https://archive.org/download/debian9newmoonia32-31.4.2.linux-i686-gtk2.tar'

newmoon-ia32/%.xz.sfs: newmoon-ia32/%.tar.xz
	$(XZSFS)

newmoon-ia32/%.zstd.sfs: newmoon-ia32/%.tar.xz
	$(ZSTDSFS)

newmoon-ia32/%.tar.xz:
	mkdir -p -- '$(@D)'
	$(CURL) -o '$(@)' '$(NEWMOONIA32_DL)$(@F)'

clean:
	rm -rf -- newmoon newmoon-sse newmoon-ia32

rebuild: clean
	$(MAKE)

publish:
	for tag in newmoon newmoon-sse newmoon-ia32; do \
		find "$(DIR)/$${tag}" ! -name '*.sfs' -type f -exec glab release create "$${tag}" --name "$${tag}" --notes "SFS Files" --no-update --use-package-registry '{}' +; \
	done

unpublish:
        for tag in $(TAGS); do \
                if glab release view "$${tag}" >/dev/null 2>&1; then \
                        glab release delete "$${tag}" -y; \
                fi; \
        done

# Message
# =======

help:
	echo 'ファイルを作成する。'
	echo
	echo 'USAGE:'
	echo '  make [OPTION...] [MACRO=VALUE...] [TARGET...]'
	echo
	echo 'TARGET:'
	echo '  all       全てのファイルを作成する。'
	echo '  clean     作成したファイルを削除する。'
	echo '  rebuild   cleanの実行後にallを実行する。'
	echo '  publish   リリースページを作成する。'
	echo '  unpublish リリースページを削除する。'
	echo '  help      このヘルプを表示して終了する。'
	echo '  version   バージョン情報を表示して終了する。'

version:
	echo '$(VERSION)'

