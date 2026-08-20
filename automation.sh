#!/bin/sh

### Script: automation.sh
##
## 自動実行用のスクリプト。
##
## Metadata:
##
##   id - 260ff918-6dc8-4fd1-8be9-4fd466c0fc5f
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 1.0.2
##   created - 2026-02-14
##   modified - 2026-08-21
##   copyright - Copyright (C) 2026-2026 qq542vev. All rights reserved.
##   license - <GPL-3.0-only at https://www.gnu.org/licenses/gpl-3.0.txt>
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/newmoon-sfs>
##   * <Bag report at https://github.com/qq542vev/newmoon-sfs/issues>

# エラー発生時に即座に終了し、未定義変数の使用を防ぐ
set -efuo pipefail

# ビルド成果物および処理済みマーカーファイルを格納するディレクトリ
readonly DIR='build'

# 1. SSH / Git の認証・設定
# =========================

# CI環境からGitリポジトリへのプッシュを可能にするためのSSH接続設定
chmod 400 "${SSH_PRIVATE_KEY}"
git config core.sshCommand "ssh -i ${SSH_PRIVATE_KEY} -o IdentitiesOnly=yes -o UserKnownHostsFile=known_hosts -o StrictHostKeyChecking=yes"

# 自動コミット用のGitユーザー情報を設定
git config user.name 'qq542vev'
git config user.email 'qq542vev@yahoo.co.jp'

# 2. リポジトリの同期と必要ファイルの取得
# =======================================

# リモートの最新情報を取得し、automationブランチ（処理済み履歴管理用）に切り替え
git fetch --depth=1 origin '+refs/heads/*:refs/remotes/origin/*'
git checkout -B automation origin/automation

# masterブランチから最新のビルド設定（GNUmakefile）とルート構成（root/）を取得
git checkout origin/master -- GNUmakefile root

# 3. ビルドとパブリッシュ
# =======================

# SFSイメージの生成と外部ストレージへのアップロードを実行
make MIN_AGE=86400 all publish

# 4. 処理済みマーカーの作成とコミット・プッシュ
# =============================================

# Gitの容量を圧迫しないよう、処理完了した実ファイルをサイズ0（空ファイル）にして処理済み状態を記録
find -- "${DIR}" -type f ! -size 0 -exec sh "-${-}c" 'for f in "${@}"; do : >"${f}"; done' sh '{}' +

# 処理済みマーカーの差分をステージング
git add -- "${DIR}"

# buildディレクトリに変更（新規・更新）がなければ正常終了
git diff --cached --quiet -- "${DIR}" && exit

# 差分がある場合のみコミットしてautomationブランチへプッシュ
git commit -m 'automation: mark processed files' -- "${DIR}"
git push "${SSH_URL}" HEAD
