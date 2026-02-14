#!/bin/sh

set -eu

readonly DIR='build'

chmod 400 "${SSH_PRIVATE_KEY}"
git config core.sshCommand "ssh -i ${SSH_PRIVATE_KEY} -o IdentitiesOnly=yes -o UserKnownHostsFile=known_hosts -o StrictHostKeyChecking=yes"
git config user.name 'qq542vev'
git config user.email 'qq542vev@yahoo.co.jp'

git fetch --depth=1 origin '+refs/heads/*:refs/remotes/origin/*'

git checkout -B automation origin/automation
git checkout origin/master -- GNUmakefile rootfs

make SHELL=bash build/newmoon-3dnow/debain8gcc7+newmoon3dnow-32.3.1.linux-i586-gtk2.zstd.sfs publish

find "${DIR}" -type f ! -size 0 -exec sh -euc 'for f in "${@}"; do : >"${f}"; done' sh '{}' +

case "$(git status --porcelain "${DIR}")" in
	'') exit 0;;
esac

git add "${DIR}"
git commit -m 'automation: mark processed files' "${DIR}"
git push 'git@gitlab.com:qq542vev/newmoon-sfs.git' 'HEAD:automation'
