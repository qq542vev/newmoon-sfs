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
##   depends - find, glab, mkdir, mv, rm, tar, test
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

VERSION = 1.0.0
TAG_PREF = 2026.01.26-

DIR = build
VARIANTS = newmoon newmoon-sse newmoon-ia32
CURL = curl -fLsS
FILES = DIR='$(@D)/' EXT='$(@F).sfs' jq -r '.files[] | select(.name | test("newmoon.*\\.tar\\.xz$$")) | env.DIR + (.name | sub("tar\\.xz$$"; env.EXT))' '$(<)'

NEWMOON_DL = https://archive.org/download/centos7newmoon-32.0.0.linux-i686-gtk2.tar/
NEWMOONSSE_DL = https://archive.org/metadata/debian9newmoonsse-31.4.2.linux-i686-gtk2.tar/
NEWMOONIA32_DL = https://archive.org/download/debian9newmoonia32-31.4.2.linux-i686-gtk2.tar/

EXTRACT = \
	dir=$$(mktemp -d) && \
	trap 'rm -rf -- "$${dir}"' EXIT && \
	cp -R -- rootfs/* "$${dir}" && \
	tar -C "$${dir}/usr/lib" -xJvf '$(<)'
MKSQUASHFS_OPTS = -all-root -no-xattrs
XZSFS = $(EXTRACT) && mksquashfs "$${dir}" '$(@)' -b 1MB -comp xz -Xbcj x86 -Xdict-size 100% $(MKSQUASHFS_OPTS)
ZSTDSFS = $(EXTRACT) && mksquashfs "$${dir}" '$(@)' -b 128KB -comp zstd -Xcompression-level 19 $(MKSQUASHFS_OPTS)

# Build Targets
# =============

all: $(VARIANTS:%=$(DIR)/%/all)

$(DIR)/%/all: $(DIR)/%/xz $(DIR)/%/zstd
	:

$(DIR)/%/xz: %.json
	$(MAKE) $$($(FILES))

$(DIR)/%/zstd: %.json
	$(MAKE) $$($(FILES))

newmoon.json:
	url='$(NEWMOON_DL)' && $(CURL) -o '$(@)' "$${url%%download*}metadata$${url#*download}"

$(DIR)/newmoon/%.xz.sfs: $(DIR)/newmoon/%.tar.xz
	$(XZSFS)

$(DIR)/newmoon/%.zstd.sfs: $(DIR)/newmoon/%.tar.xz
	$(ZSTDSFS)

$(DIR)/newmoon/%.tar.xz:
	mkdir -p -- '$(@D)'
	$(CURL) -o '$(@)' '$(NEWMOON_DL)$(@F)'

newmoon-sse.json:
	url='$(NEWMOONSSE_DL)' && $(CURL) -o '$(@)' "$${url%%download*}metadata$${url#*download}"

$(DIR)/newmoon-sse/%.xz.sfs: $(DIR)/newmoon-sse/%.tar.xz
	$(XZSFS)

$(DIR)/newmoon-sse/%.zstd.sfs: $(DIR)/newmoon-sse/%.tar.xz
	$(ZSTDSFS)

$(DIR)/newmoon-sse/%.tar.xz:
	mkdir -p -- '$(@D)'
	$(CURL) -o '$(@)' '$(NEWMOONSSE_DL)$(@F)'

newmoon-ia32.json:
	url='$(NEWMOONIA32_DL)' && $(CURL) -o '$(@)' "$${url%%download*}metadata$${url#*download}"

$(DIR)/newmoon-ia32/%.xz.sfs: $(DIR)/newmoon-ia32/%.tar.xz
	$(XZSFS)

$(DIR)/newmoon-ia32/%.zstd.sfs: $(DIR)/newmoon-ia32/%.tar.xz
	$(ZSTDSFS)

$(DIR)/newmoon-ia32/%.tar.xz:
	mkdir -p -- '$(@D)'
	$(CURL) -o '$(@)' '$(NEWMOONIA32_DL)$(@F)'

clean:
	rm -rf -- '$(DIR)'

rebuild: clean
	$(MAKE)

publish:
	for variant in $(VARIANTS); do \
		git tag "$(TAG_PREF)$${variant}" && \
		git push origin "$(TAG_PREF)$${variant}" && \
		find "$(DIR)/$${variant}" -name '*.sfs' -type f -exec glab release create "$(TAG_PREF)$${variant}" --name "$${variant}" --notes 'SFS Files' --no-update --use-package-registry '{}' +; \
	done

unpublish:
	for variant in $(VARIANTS); do \
		if glab release view "$(TAG_PREF)$${variant}" >/dev/null 2>&1; then \
			glab release delete "$(TAG_PREF)$${variant}" -y; \
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
