#!/bin/bash

# an array for the arguments
declare -a args

# loop over all MP4 files
for mkv in *.mkv ; do
  base="${mkv%mkv}"
  args=(-o "\"output/${base}mkv\"" "\"${mkv}\"")

  # look for subtitles with the same base name
  if [[ -f "${base}ass" ]]; then
    args=("${args[@]}" "\"${base}ass\"")
  fi

  # create output file
  mkvmerge "${args[@]}"
done