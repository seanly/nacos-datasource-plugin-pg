variable "VERSION" {
  default = "2.4.1-2"
}

variable "DATABASE" {
  default = "pg"
}

variable "FIXID" {
  default = "1"
}

group "default" {
  targets = ["nacos"]
}

target "nacos" {
    labels = {
        "cloud.opsbox.author" = "seanly"
        "cloud.opsbox.image.name" = "nacos"
        "cloud.opsbox.image.version" = "${VERSION}-${DATABASE}"
        "cloud.opsbox.image.fixid" = "${FIXID}"
    }
    dockerfile = "package/bake/Dockerfile"
    context  = "."
    args = {
        NACOS_VERSION="${VERSION}"
    }
    platforms = ["linux/amd64", "linux/arm64"]
    tags = ["seanly/appset:nacos-${VERSION}-${DATABASE}-${FIXID}"]
    output = ["type=image,push=true"]
}

variable "ACR_REGISTRY" {
  default = "registry.cn-chengdu.aliyuncs.com"
}

group "acr" {
  targets = ["nacos-amd64", "nacos-arm64"]
}

target "nacos-amd64" {
    labels = {
        "cloud.opsbox.author" = "seanly"
        "cloud.opsbox.image.name" = "nacos"
        "cloud.opsbox.image.version" = "${VERSION}-${DATABASE}"
        "cloud.opsbox.image.fixid" = "${FIXID}"
    }
    dockerfile = "package/bake/Dockerfile"
    context  = "."
    args = {
        NACOS_VERSION="${VERSION}"
    }
    platforms = ["linux/amd64"]
    tags = [
      "${ACR_REGISTRY}/seanly/appset:nacos-${VERSION}-${DATABASE}-${FIXID}",
      "${ACR_REGISTRY}/seanly/appset:nacos-${VERSION}-${DATABASE}-${FIXID}-amd64"
    ]
    output = ["type=image,push=true"]
}

target "nacos-arm64" {
    labels = {
        "cloud.opsbox.author" = "seanly"
        "cloud.opsbox.image.name" = "nacos"
        "cloud.opsbox.image.version" = "${VERSION}-${DATABASE}"
        "cloud.opsbox.image.fixid" = "${FIXID}"
    }
    dockerfile = "package/bake/Dockerfile"
    context  = "."
    args = {
        NACOS_VERSION="${VERSION}"
    }
    platforms = ["linux/arm64"]
    tags = [
      "${ACR_REGISTRY}/seanly/appset:nacos-${VERSION}-${DATABASE}-${FIXID}-arm64"
    ]
    output = ["type=image,push=true"]
}