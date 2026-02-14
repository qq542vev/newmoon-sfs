#!/bin/sh

### Script: automation.sh
##
## 自動実行用のスクリプト。
##
## Metadata:
##
##   id - 260ff918-6dc8-4fd1-8be9-4fd466c0fc5f
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 1.0.0
##   created - 2026-02-14
##   modified - 2026-02-14
##   copyright - Copyright (C) 2026-2026 qq542vev. All rights reserved.
##   license - <GPL-3.0-only at https://www.gnu.org/licenses/gpl-3.0.txt>
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/newmoon-sfs>
##   * <Bag report at https://github.com/qq542vev/newmoon-sfs/issues>

set -efuo pipefail

readonly DIR='build'

chmod 400 "${SSH_PRIVATE_KEY}"
git config core.sshCommand "ssh -i ${SSH_PRIVATE_KEY} -o IdentitiesOnly=yes -o UserKnownHostsFile=known_hosts -o StrictHostKeyChecking=yes"
git config user.name 'qq542vev'
git config user.email 'qq542vev@yahoo.co.jp'

git fetch --depth=1 origin '+refs/heads/*:refs/remotes/origin/*'
git checkout -B automation origin/automation
git checkout origin/master -- GNUmakefile rootfs

make SHELL=/bin/bash all publish

find -- "${DIR}" -type f ! -size 0 -exec sh -euc 'for f in "${@}"; do : >"${f}"; done' sh '{}' +

case "$(git status --porcelain -- "${DIR}")" in
	'') exit 0;;
esac

git add -- "${DIR}"
git commit -m 'automation: mark processed files' -- "${DIR}"
git push origin HEAD
