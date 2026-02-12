#!/bin/sh

set -eu

git config user.name 'qq542vev'
git config user.email 'qq542vev@yahoo.co.jp'

git checkout -B automation

make all publish

find build -type f ! -empty -exec sh -euc 'for f in "${@}"; do : >"${f}"; done' sh '{}' +

git status --porcelain | grep . || exit 0
git add -A
git commit -m 'automation: mark processed files'
git push "https://gitlab-ci-token:${CI_JOB_TOKEN}@gitlab.com/q542vev/newmoon-sfs.git" 'HEAD:automation'
