#!/bin/sh
set -o errexit
mkdir -p ./build
javac -classpath ".;./src/*;./src" -d "./build"  ./src/*
cd build
java WebServer
