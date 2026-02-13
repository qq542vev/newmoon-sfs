#!/bin/sh

set -eu

git config user.name 'qq542vev'
git config user.email 'qq542vev@yahoo.co.jp'

git fetch --depth=1 origin '+refs/heads/*:refs/remotes/origin/*'

git branch -a
git checkout -B automation origin/automation
git checkout origin/master -- GNUmakefile rootfs

make SHELL=bash build/newmoon-3dnow/debain8gcc7+newmoon3dnow-32.3.1.linux-i586-gtk2.xz.sfs publish

find build -type f ! -size 0 -exec sh -euc 'for f in "${@}"; do : >"${f}"; done' sh '{}' +

git status --porcelain | grep . || exit 0
git add build
git commit -m 'automation: mark processed files' build

git push "https://token:${GITLAB_TOKEN}@gitlab.com/q542vev/newmoon-sfs.git" 'HEAD:automation'
