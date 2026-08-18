### File: docker-bake.hcl
##
## NewMoon SFSのmake環境のためのイメージ。
##
## Usage:
##
## ------ Text ------
## docker buildx bake -f docker-bake.hcl
## ------------------
##
## Env variable:
##
##   IMG - ベースイメージ。
##   IMG_CREATED - org.opencontainers.image.createdの値。
##   IMG_DESC - org.opencontainers.image.descの値。
##   IMG_LICENSE- org.opencontainers.image.licenseの値。
##   IMG_TITLE - org.opencontainers.image.titleの値。
##   IMG_URL - org.opencontainers.image.urlの値。
##   IMG_VER - org.opencontainers.image.versionの値。
##
## Metadata:
##
##   id - 81884107-e161-4fa0-95fd-dee08cec1472
##   author - <qq542vev at https://purl.org/meta/me/>
##   version - 1.0.0
##   created - 2026-02-14
##   modified - 2026-02-14
##   copyright - Copyright (C) 2026-2026 qq542vev. All rights reserved.
##   license - <GPL-3.0-only at https://www.gnu.org/licenses/gpl-3.0.txt>
##   conforms-to - <https://docs.docker.com/build/bake/reference/>
##
## See Also:
##
##   * <Project homepage at https://github.com/qq542vev/newmoon-sfs>
##   * <Bug report at https://github.com/qq542vev/newmoon-sfs/issues>

variable "IMG" {default = "ubuntu:26.04"}
variable "IMG_AUTHS" {default = "qq542vev <https://purl.org/meta/me/>"}
variable "IMG_CREATED" {default = timestamp()}
variable "IMG_DESC" {default = "NewMoon SFSのビルド成果物（SFSファイル）を含むイメージ。"}
variable "IMG_LICENSE" {default = ""}
variable "IMG_TITLE" {default = "NewMoon SFS Make"}
variable "IMG_URL" {default = "https://github.com/qq542vev/newmoon-sfs"}
variable "IMG_VER" {default = "2026-02-14"}
variable "labels" {
  default = {
    "org.opencontainers.image.created" = IMG_CREATED
    "org.opencontainers.image.authors" = IMG_AUTHS
    "org.opencontainers.image.url" = IMG_URL
    "org.opencontainers.image.version" = IMG_VER
    "org.opencontainers.image.license" = IMG_LICENSE
    "org.opencontainers.image.title" = IMG_TITLE
    "org.opencontainers.image.description" = IMG_DESC
  }
}
variable "tags" {
  default = [
    "ghcr.io/qq542vev/newmoon-sfs:${IMG_VER}",
    "registry.gitlab.com/qq542vev/newmoon-sfs:${IMG_VER}"
  ]
}

target "default" {
  context = "."
  dockerfile = "Dockerfile"
  platforms = ["linux/amd64", "linux/arm/v7", "linux/arm64/v8", "linux/ppc64le", "linux/riscv64", "linux/s390x"]
  labels = labels
  annotations = formatlist("%s=%s", keys(labels), values(labels))
  output = ["type=registry"]
  args = {
    IMAGE = IMG
  }
  tags = tags
}
