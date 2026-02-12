#!/bin/sh

set -eu

git config user.name 'qq542vev'
git config user.email 'qq542vev@yahoo.co.jp'

git checkout -B automation origin/automation
git checkout origin/master -- makefile

make all publish

find build -type f ! -empty -exec sh -euc 'for f in "${@}"; do : >"${f}"; done' sh '{}' +

git status --porcelain | grep . || exit 0
git add build
git commit -m 'automation: mark processed files'
git push "https://token:${GITLAB_TOKEN}@gitlab.com/q542vev/newmoon-sfs.git" 'HEAD:automation'
