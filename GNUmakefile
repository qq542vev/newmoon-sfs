#!/usr/bin/gmake -f

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
##   modified - 2026-01-30
##   copyright - Copyright (C) 2026-2026 qq542vev. All rights reserved.
##   license - <GPL-3.0-only at https://www.gnu.org/licenses/gpl-3.0.txt>
##   depends - find, glab, mkdir, mksquashfs, mv, rm, tar
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/newmoon-sfs>
##   * <Bag report at https://github.com/qq542vev/newmoon-sfs/issues>

# Sp Targets
# ==========

.PHONY: all clean rebuild update publish unpublish help version

.SILENT: help version

# Macro
# =====

.SHELLFLAGS = -efuo pipefail -c

VERSION = 1.0.0
DATE = 2026-01-26

DIR = build
VARIANTS = newmoon newmoon-sse newmoon-ia32 newmoon-3dnow
CURL = curl -fLsS
FILES = DIR='$(@D)/' EXT='$(@F).sfs' jq -r '.files[] | select(.name | test("newmoon.*\\.tar\\.xz$$")) | env.DIR + (.name | sub("tar\\.xz$$"; env.EXT))' '$(<)'

NEWMOON_DL = https://archive.org/download/centos7newmoon-32.0.0.linux-i686-gtk2.tar/
NEWMOONSSE_DL = https://archive.org/download/debian9newmoonsse-31.4.2.linux-i686-gtk2.tar/
NEWMOONIA32_DL = https://archive.org/download/debian9newmoonia32-31.4.2.linux-i686-gtk2.tar/
NEWMOON3DNOW_DL = https://archive.org/download/debian8newmoon3dnow-29.1.0.linux-i586-gtk2.tar/

EXTRACT = \
	dir=$$(mktemp -u) && \
	trap 'rm -rf -- "$${dir}"' EXIT && \
	cp -pR -- rootfs "$${dir}" && \
	tar -C "$${dir}/usr/lib" -xJvf '$(<)'
MKSQUASHFS_OPTS = -all-root -root-mode 0755 -no-xattrs
XZSFS = $(EXTRACT) && mksquashfs "$${dir}" '$(@)' -b 1M -comp xz -Xbcj x86 -Xdict-size 100% $(MKSQUASHFS_OPTS)
ZSTDSFS = $(EXTRACT) && mksquashfs "$${dir}" '$(@)' -b 128K -comp zstd -Xcompression-level 19 $(MKSQUASHFS_OPTS)

# Build Targets
# =============

all: $(VARIANTS:%=$(DIR)/%/all)

$(DIR)/%/all: $(DIR)/%/xz $(DIR)/%/zstd
	:

$(DIR)/%/xz: %.json
	$(MAKE) $$($(FILES))

$(DIR)/%/zstd: %.json
	$(MAKE) $$($(FILES))

$(DIR)/%.xz.sfs: $(DIR)/%.tar.xz
	$(XZSFS)

$(DIR)/%.zstd.sfs: $(DIR)/%.tar.xz
	$(ZSTDSFS)

newmoon.json:
	url='$(NEWMOON_DL)' && $(CURL) -o '$(@)' "$${url%%download*}metadata$${url#*download}"

$(DIR)/newmoon/%.tar.xz:
	mkdir -p -- '$(@D)'
	$(CURL) -o '$(@)' '$(NEWMOON_DL)$(@F)'

newmoon-sse.json:
	url='$(NEWMOONSSE_DL)' && $(CURL) -o '$(@)' "$${url%%download*}metadata$${url#*download}"

$(DIR)/newmoon-sse/%.tar.xz:
	mkdir -p -- '$(@D)'
	$(CURL) -o '$(@)' '$(NEWMOONSSE_DL)$(@F)'

newmoon-ia32.json:
	url='$(NEWMOONIA32_DL)' && $(CURL) -o '$(@)' "$${url%%download*}metadata$${url#*download}"

$(DIR)/newmoon-ia32/%.tar.xz:
	mkdir -p -- '$(@D)'
	$(CURL) -o '$(@)' '$(NEWMOONIA32_DL)$(@F)'

newmoon-3dnow.json:
	url='$(NEWMOON3DNOW_DL)' && $(CURL) -o '$(@)' "$${url%%download*}metadata$${url#*download}"

$(DIR)/newmoon-3dnow/%.tar.xz:
	mkdir -p -- '$(@D)'
	$(CURL) -o '$(@)' '$(NEWMOON3DNOW_DL)$(@F)'

clean:
	rm -rf -- $(VARIANTS:%='%.json') '$(DIR)'

rebuild: clean
	$(MAKE)

publish:
	for variant in $(VARIANTS); do \
		find "$(DIR)/$${variant}" -name '*.sfs' -type f -print -exec sh -c 'glab api -X PUT "projects/:id/packages/generic/$${1}/$(DATE)/$${2##*/}" --input "$${2}"' sh "$${variant}" '{}' ';'; \
	done

unpublish:
	for url in $$(glab api 'projects/:id/packages' | jq -r --arg names '$(VARIANTS)' --arg ver '$(DATE)' '.[] | select(.name as $$n | ($$names | split(" ") | index($$n)) and .version == $$ver) | ._links.delete_api_path'); do glab api --method DELETE "$${url}"; done

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
