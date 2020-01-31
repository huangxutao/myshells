#!/bin/bash

rootDir=`pwd`
tmpDir=$rootDir/.tmp

rm -rf $tmpDir

mkdir $tmpDir

export tmpDir=$tmpDir
