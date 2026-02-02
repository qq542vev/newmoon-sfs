<!-- Document: README.md

「New Moon SFS」の日本語マニュアル。

Metadata:

	id - 359da752-1be7-4070-9c83-e30a5c3e0c3c
	author - <qq542vev at https://purl.org/meta/me/>
	version - 0.1.0
	created - 2026-02-02
	modified - 2026-02-02
	copyright - Copyright (C) 2026-2026 qq542vev. Some rights reserved.
	license - <GPL-3.0-only at https://www.gnu.org/licenses/gpl-3.0.txt>
	conforms-to - <https://spec.commonmark.org/current/>

See Also:

	* <Project homepage at https://github.com/qq542vev/newmoon-sfs>
	* <Bug report at https://github.com/qq542vev/newmoon-sfs/issues>
-->

# New Moon SFS

New Moon SFSはFenyőさんが作成したのNew Moon([Pale Noon](https://www.palemoon.org/)の変異版)をPuppy Linux用にSFS(SquashFS)ファイルとして再配布するプロジェクトです。2026年02月現在次のNew Moonを再配布しています。

 * [New Moon](https://archive.org/download/centos7newmoon-32.0.0.linux-i686-gtk2.tar/)(x86, SSE2対応版)
 * [New Moon SSE](https://archive.org/download/debian9newmoonsse-31.4.2.linux-i686-gtk2.tar/)(x86, SSE対応版)
 * [New Moon IA32](https://archive.org/download/debian9newmoonia32-31.4.2.linux-i686-gtk2.tar/)(x86, CMO対応版)
 * [New Moon 3DNow](https://archive.org/download/debian8newmoon3dnow-29.1.0.linux-i586-gtk2.tar/)(x86, 3DNow対応版)

New Moonについてのより詳しい情報は[AntiX Forumへの投稿](https://www.antixforum.com/forums/topic/browsers-for-old-cpus/page/10/#post-104401)を参照してください。

## ダウンロード

[Package registry](https://gitlab.com/qq542vev/newmoon-sfs/-/packages/)から必要なSFSファイルをダウンロードしてください。SFSファイルにはxz圧縮とzstd圧縮のものが存在します。

| 比較                 | xz   | zstd |
| ==================== | ==== | ==== |
| 圧縮率               | 最良 | 良   |
| 展開速度             | 低速 | 中速 |
| 展開時のメモリ使用量 | 大   | 小   |
