#!/bin/bash

path=`dirname $0`
trap "exit" SIGINT SIGTERM
trap "cleanup" EXIT

cleanup () {
  trap '' INT TERM     # ignore INT and TERM while shutting down
  echo "[WATCHER]- **** Shutting down watch... ****"
  kill -TERM 0 > /dev/null 2>&1
  wait
  echo "[WATCHER]- **** DONE WATCH ****"
}

cd $path

Build () {
  /bin/bash ./build-and-run.sh &
  BPID=$!
}

Build
while read line;
do
  echo "[WATCHER]- $line"
  if [[ $line == *"watch-change"* ]]
  then
    kill $BPID > /dev/null 2>&1
    wait $BPID
    Build
    sleep 2
  fi
done < <(inotifywait -r -m -e close_write -e move -e create -e delete --format "watch-change: %e %w" ./src)
