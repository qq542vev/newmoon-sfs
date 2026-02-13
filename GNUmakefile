#!/usr/bin/gmake -f

### Script: GNUmakefile
##
## ファイルを作成する。
##
## Metadata:
##
##   id - 0f626fa2-2e49-42b0-8351-f44bd6ab4c34
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 1.0.3
##   created - 2026-01-22
##   modified - 2026-02-13
##   copyright - Copyright (C) 2026-2026 qq542vev. All rights reserved.
##   license - <GPL-3.0-only at https://www.gnu.org/licenses/gpl-3.0.txt>
##   depends - curl, find, mkdir, mksquashfs, rclone, rm, tar
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

VERSION = 1.0.3

VARIANTS = newmoon newmoon-sse newmoon-ia32 newmoon-3dnow
DIR = build
CURL = curl -fLsSo
MKDIR = mkdir -p --
RCLONE = rclone

FILES = DIR='$(@D)/' EXT='$(@F).sfs' jq -r '.files[] | select(.name | test("newmoon.*\\.tar\\.xz$$")) | env.DIR + (.name | sub("tar\\.xz$$"; env.EXT))' '$(<)'

NEWMOON_URL = https://archive.org/download/centos7newmoon-32.0.0.linux-i686-gtk2.tar/
NEWMOONSSE_URL = https://archive.org/download/debian9newmoonsse-31.4.2.linux-i686-gtk2.tar/
NEWMOONIA32_URL = https://archive.org/download/debian9newmoonia32-31.4.2.linux-i686-gtk2.tar/
NEWMOON3DNOW_URL = https://archive.org/download/debian8newmoon3dnow-29.1.0.linux-i586-gtk2.tar/

EXTRACT = \
	dir=$$(mktemp -u) && \
	trap 'rm -rf -- "$${dir}"' EXIT && \
	cp -pR -- rootfs "$${dir}" && \
	tar -C "$${dir}/usr/lib" -xJvf '$(<)'

SFS_OPTS = -all-root -root-mode 0755 -no-xattrs
XZ_OPTS = $(SFS_OPTS) -b 1M -Xbcj x86 -Xdict-size 100%
ZSTD_OPTS = $(SFS_OPTS) -b 128K -Xcompression-level 19
MKSFS = mksquashfs
MKXZSFS = $(EXTRACT) && $(MKSFS) "$${dir}" '$(@)' -comp xz $(XZ_OPTS)
MKZSTDSFS = $(EXTRACT) && $(MKSFS) "$${dir}" '$(@)' -comp zstd $(ZSTD_OPTS)

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
	$(MKXZSFS)

$(DIR)/%.zstd.sfs: $(DIR)/%.tar.xz
	$(MKZSTDSFS)

newmoon.json:
	url='$(NEWMOON_URL)' && $(CURL) '$(@)' "$${url%%download*}metadata$${url#*download}"

$(DIR)/newmoon/%.tar.xz:
	$(MKDIR) '$(@D)'
	$(CURL) '$(@)' '$(NEWMOON_URL)$(@F)'

newmoon-sse.json:
	url='$(NEWMOONSSE_URL)' && $(CURL) '$(@)' "$${url%%download*}metadata$${url#*download}"

$(DIR)/newmoon-sse/%.tar.xz:
	$(MKDIR) '$(@D)'
	$(CURL) '$(@)' '$(NEWMOONSSE_URL)$(@F)'

newmoon-ia32.json:
	url='$(NEWMOONIA32_URL)' && $(CURL) '$(@)' "$${url%%download*}metadata$${url#*download}"

$(DIR)/newmoon-ia32/%.tar.xz:
	$(MKDIR) '$(@D)'
	$(CURL) '$(@)' '$(NEWMOONIA32_URL)$(@F)'

newmoon-3dnow.json:
	url='$(NEWMOON3DNOW_URL)' && $(CURL) '$(@)' "$${url%%download*}metadata$${url#*download}"

$(DIR)/newmoon-3dnow/%.tar.xz:
	$(MKDIR) '$(@D)'
	$(CURL) '$(@)' '$(NEWMOON3DNOW_URL)$(@F)'

clean:
	rm -rf -- $(VARIANTS:%='%.json') '$(DIR)'

rebuild: clean
	$(MAKE)

publish:
	for variant in $(VARIANTS); do \
		if [ -d "$(DIR)/$${variant}" ]; then \
			find "$(DIR)/$${variant}" -name '*.sfs' -type f ! -size 0 -print -exec $(RCLONE) copy '{}' 'newmoon-sfs:' ';'; \
		fi; \
	done

unpublish:
	$(RCLONE) purge newmoon-sfs:

# Docs
# ====

LICENSE.txt:
	$(CURL) '$(@)' 'https://www.gnu.org/licenses/gpl-3.0.txt'

# Message
# =======

help:
	echo 'ファイルを作成する。'
	echo
	echo 'USAGE:'
	echo '  make [OPTION...] [MACRO=VALUE...] [TARGET...]'
	echo
	echo 'MACRO:'
	echo '  SFS_OPTS  mksquashfsの共通オプション。'
	echo '  XZ_OPTS   mksquashfs -comp xz時のオプション。'
	echo '  ZSTD_OPTS mksquashfs -comp zstd時のオプション。'
	echo
	echo 'TARGET:'
	echo '  all       全てのファイルを作成する。'
	echo '  clean     作成したファイルを削除する。'
	echo '  rebuild   cleanの実行後にallを実行する。'
	echo '  publish   リモートにSFSを公開する。'
	echo '  unpublish リモートのSFSを削除する。'
	echo '  help      このヘルプを表示して終了する。'
	echo '  version   バージョン情報を表示して終了する。'

version:
	echo '$(VERSION)'
