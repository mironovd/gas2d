#! /bin/bash
trap "pkill -P $$; kill -INT $$" INT

while read n
do
    "$@" &
    sleep 0.001
done < <(seq 30)
wait