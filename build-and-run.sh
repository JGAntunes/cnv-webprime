#!/bin/sh
set -o errexit

path=`dirname $0`

cd $path
rm -rf ./build
mkdir -p ./build
javac -d "./build"  ./src/*
java -classpath ".;./build/*:./build" WebServer
