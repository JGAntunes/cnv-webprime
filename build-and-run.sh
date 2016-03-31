#!/bin/sh

javac -classpath ".;./src/*;./src" -d "./build"  ./src/*
cd build
java WebServer
