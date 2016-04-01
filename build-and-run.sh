#!/bin/bash

path=`dirname $0`
trap "exit" SIGINT SIGTERM
trap "cleanup" EXIT

cleanup () {
  trap '' INT TERM     # ignore INT and TERM while shutting down
  kill -TERM $JPID > /dev/null 2>&1
  wait
  echo "**** DONE SERVER ****"
}

cd $path

rm -rf ./build
mkdir -p ./build
javac -d "./build"  ./src/*
java -classpath ".;./build/*:./build" WebServer &
JPID=$!
wait $JPID
