#!/bin/bash

# set -e
set -o errexit

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
nginxDir='nginx'

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

  # 安装依赖
  echo "🛠️  安装依赖..."
  echo "> cd $wwwDir$basePath && npm i && cd $rootDir"
  cd $wwwDir$basePath && npm i && cd $rootDir
  echo ""

  # 配置 nginx
  echo "🛠️  配置 nginx..."
  cp "$rootDir/nginx.conf/note-api" "$nginxDir/sites-available/"
  ln -s "$nginxDir/sites-available/note-api" "$nginxDir/sites-enabled/note-api"
  sed -ie "s/_DOMAIN_/$rootDomain/" "$nginxDir/sites-available/note-api"
  systemctl reload nginx
  echo "✅ nginx ok."

  # 数据库同步
  echo "🛠️  数据库同步..."
  # mongorestore -h 127.0.0.1:27017 -d note_life <path>
  echo "✅ 数据库同步 ok."
}

setManage() {
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
  cp "$rootDir/nginx.conf/note-manage" "$nginxDir/sites-available/"
  ln -s "$nginxDir/sites-available/note-manage" "$nginxDir/sites-enabled/note-manage"
  sed -ie "s/_DOMAIN_/$rootDomain/" "$nginxDir/sites-available/note-manage"
  systemctl reload nginx
  echo "✅ nginx ok."
}

setTheme() {
  basePath="/note-life\/note"
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
  cp "$rootDir/nginx.conf/note" "$nginxDir/sites-available/"
  ln -s "$nginxDir/sites-available/note" "$nginxDir/sites-enabled/note"
  sed -ie "s:_STATICPATH_:${staticPATH}:" "$nginxDir/sites-available/note"
  sed -ie "s:_DOMAIN_:${rootDomain}:" "$nginxDir/sites-available/note"
  rm "$nginxDir/sites-available/notee"
  systemctl reload nginx
  echo "✅ nginx ok."
}

# setCore

# setManage

setTheme

