#!/bin/sh

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

find "${DIR}" -type f ! -size 0 -exec sh -euc 'for f in "${@}"; do : >"${f}"; done' sh '{}' +

case "$(git status --porcelain "${DIR}")" in
	'') exit 0;;
esac

git add "${DIR}"
git commit -m 'automation: mark processed files' "${DIR}"
git push origin 'HEAD:automation'
