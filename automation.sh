#!/bin/sh

set -eu

git config user.name 'qq542vev'
git config user.email 'qq542vev@yahoo.co.jp'

git fetch --depth=1 origin '+refs/heads/*:refs/remotes/origin/*'

git branch -a
git checkout -B automation origin/automation
git checkout origin/master -- makefile

make build/3dnow/all publish

find build -type f ! -empty -exec sh -euc 'for f in "${@}"; do : >"${f}"; done' sh '{}' +

git status --porcelain | grep . || exit 0
git add build
git commit -m 'automation: mark processed files'
git push "https://token:${GITLAB_TOKEN}@gitlab.com/q542vev/newmoon-sfs.git" 'HEAD:automation'
