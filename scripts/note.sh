#!/bin/bash

set -e
# set -o errexit

source ./utils/get-domain.sh  # get domain & import variable -> rootDomain
source ./utils/set-tmp.sh  # set tmp dir & import variable -> tmpDir
source ./utils/check-www.sh  # checkdir & import variable -> wwwDir

# 移动目录 对目标路径做备份
saveMv() {
  date=`date "+%Y-%m-%d %H:%M:%S"`

  if [ -d $2 ]; then
    mv $2 "$2.$date"
    echo "🚧  directory already exists: $2"
    echo "🚧  move to $2.$date"
  fi

  echo "> mv $1 $2"
  mv $1 $2
  echo ""
}


rootDir=`pwd`
nginxDir='/etc/nginx'

echo "=========================================================="
echo "🟢  root domian: $rootDomain"
echo "🟢  root dir: $rootDir"
echo "🟢  tmp dir: $tmpDir"
echo "🟢  wwww dir: $wwwDir"
echo "🟢  nginx dir: $nginxDir"
echo "=========================================================="
echo ""

coreGitRepository="https://github.com/note-life/core.git"
manageGitRepository="https://github.com/note-life/manage-default.git"
themeGitRepository="https://github.com/note-life/theme-default.git"

setCore() {
  echo ""
  echo "🛵🛵🛵  note api 安装"
  basePath="/note-life/core"
  branch="master"
  repository=$coreGitRepository
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
  cp "$rootDir/nginx.conf/note-api.conf" "$nginxDir/conf.d/"
  sed -ie "s/_DOMAIN_/$rootDomain/" "$nginxDir/conf.d/note-api.conf"
  rm "$nginxDir/conf.d/note-api.confe"
  systemctl reload nginx

  # 数据库同步
  echo "🛠️  数据库同步..."
  # mongorestore -h 127.0.0.1:27017 -d note_life <path>
  echo ""
}

setManage() {
  echo ""
  echo "🛵🛵🛵  note 后台管理安装"
  basePath="/note-life/manage"
  branch="note-manage.hxtao.xyz"
  repository=$manageGitRepository
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
  cp "$rootDir/nginx.conf/note-manage.conf" "$nginxDir/conf.d/"
  sed -ie "s/_DOMAIN_/$rootDomain/" "$nginxDir/conf.d/note-manage.conf"
  rm "$nginxDir/conf.d/note-manage.confe"
  systemctl reload nginx
  echo ""
}

setTheme() {
  echo ""
  echo "🛵🛵🛵  note 主题安装"

  basePath="/note-life/note"
  branch="note.hxtao.xyz"
  staticPATH="$wwwDir$basePath"
  repository=$themeGitRepository
  codeDir="$tmpDir$basePath"

  # # 克隆源码
  echo "🛠️  克隆源码..."
  echo "> git clone -b $branch $repository $codeDir"
  git clone -b $branch $repository $codeDir
  echo ""

  # # 移动目录到 www
  echo "🛠️  移动目录到 www..."
  saveMv $codeDir $wwwDir$basePath

  # 配置 nginx
  echo "🛠️  配置 nginx..."
  cp "$rootDir/nginx.conf/note.conf" "$nginxDir/conf.d/"
  sed -ie "s:_STATICPATH_:${staticPATH}:" "$nginxDir/conf.d/note.conf"
  sed -ie "s:_DOMAIN_:${rootDomain}:" "$nginxDir/conf.d/note.conf"
  rm "$nginxDir/conf.d/note.confe"
  systemctl reload nginx
  echo ""
}

setCore

setManage

setTheme

