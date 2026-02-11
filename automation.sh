#!/bin/sh

set -eu

git clone -b automation git@github.com:qq542vev/newmoon-sfs.git work
cd -- work

mkdir -p ~/.config/rclone
printf '%s\n' "${RCLONE_CONF}" > ~/.config/rclone/rclone.conf

make
make publish

find build -type f ! -empty -exec sh -c 'for f in "${@}"; do : > "${f}"; done' sh '{}' +

git status --porcelain | grep . || exit
git commit -am 'automation: mark processed files'
git push
