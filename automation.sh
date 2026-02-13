#!/bin/sh

set -eu

readonly DIR='build'
git config user.name 'qq542vev'
git config user.email 'qq542vev@yahoo.co.jp'

git fetch --depth=1 origin '+refs/heads/*:refs/remotes/origin/*'

git branch -a
git checkout -B automation origin/automation
git checkout origin/master -- GNUmakefile rootfs

echo "RCLONE_CONFIG: $RCLONE_CONFIG"
ls -la $RCLONE_CONFIG

make SHELL=bash build/newmoon-3dnow/debain8gcc7+newmoon3dnow-32.3.1.linux-i586-gtk2.xz.sfs publish

find "${DIR}" -type f ! -size 0 -exec sh -euc 'for f in "${@}"; do : >"${f}"; done' sh '{}' +

case "$(git status --porcelain "${DIR}")" in
	'') exit 0;;
esac

git add "${DIR}"
git commit -m 'automation: mark processed files' "${DIR}"
git push "https://token:${GITLAB_TOKEN}@gitlab.com/qq542vev/newmoon-sfs.git" 'HEAD:automation'
