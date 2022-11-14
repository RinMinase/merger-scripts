#!/bin/bash

# Guide:
# mkvmerge -i "file"
# add 1 to track id

for mkv in *.{mkv,MKV} ; do
  echo ${mkv}
  mkvpropedit "${mkv}" --edit track:6 --set flag-default=1 --edit track:7 --set flag-default=0
done

sleep 2