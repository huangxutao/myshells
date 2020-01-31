#!/bin/bash

echo -n "> 请输入一级域名(default to hxtao.xyz): "

read rootDomain

if [[ $rootDomain == "" ]]; then
  rootDomain="hxtao.xyz"
fi

export rootDomain=$rootDomain
