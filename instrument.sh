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

OUT_PATH=$(cd $(dirname "./build") && pwd -P)/$(basename "./build")
INST_CLASS=$(cd $(dirname "./build/IntFactorization.class") && pwd -P)/$(basename "./build/IntFactorization.class")

rm -rf ./build
mkdir -p ./build
javac -classpath ".;./build/*:./build:./libs/*:./libs" -d "./build"  ./src/*
java -XX:-UseSplitVerifier -classpath ".;./build/*:./build:./libs/*:./libs" Instrumentation $INST_CLASS $OUT_PATH calcPrimeFactors
java -XX:-UseSplitVerifier -classpath ".;./build/*:./build" WebServer &
JPID=$!
wait $JPID
