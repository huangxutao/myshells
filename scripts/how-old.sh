#!/bin/bash

set -e

if [[ $1 != 'direct' ]]; then
  source ./utils/get-domain.sh  # get domain & import variable -> rootDomain
  source ./utils/set-tmp.sh  # set tmp dir & import variable -> tmpDir
  source ./utils/check-www.sh  # checkdir & import variable -> wwwDir
fi

gitRepository="https://github.com/huangxutao/how-old-server.git"

setCore() {
  echo ""
  echo "🛵🛵🛵  how old server 安装"
  basePath="/how-old-server"
  branch="master"
  repository=$gitRepository
  codeDir="$tmpDir$basePath"

  # 克隆源码
  echo "🛠️  克隆源码..."
  echo "> git clone -b $branch $repository $codeDir"
  git clone -b $branch $repository $codeDir
  echo ""

  # 移动目录到 www
  echo "🛠️  移动目录到 www..."
  saveMv $codeDir $wwwDir$basePath

  # 配置 nginx
  echo "🛠️  配置 nginx..."
  cp "$rootDir/nginx.conf/how-old-server.conf" "$nginxDir/conf.d/"
  sed -ie "s/_DOMAIN_/$rootDomain/" "$nginxDir/conf.d/how-old-server.conf"
  rm "$nginxDir/conf.d/how-old-server.confe"
  systemctl reload nginx
}