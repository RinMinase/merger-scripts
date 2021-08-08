#!/bin/bash

for mkv in *.mkv ; do
  echo ${mkv}
  mkvpropedit "${mkv}" --delete-attachment mime-type:image/jpeg --delete-attachment mime-type:image/png
done

sleep 2