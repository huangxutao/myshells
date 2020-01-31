#!/bin/bash

wwwDir="./www"
noteLifeDir="$wwwDir/note-life"
howOldDir="$wwwDir/how-old"

checkDir() {
  if [ ! -d $1 ]; then
    mkdir $1
  fi
}

checkDir $wwwDir

checkDir $noteLifeDir

export wwwDir=$wwwDir
