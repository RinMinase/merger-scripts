#!/bin/bash

# an array for the arguments
declare -a args
declare -a audio
declare -a subs
rm -f merge.bat

# loop over all MP4 files
for mkv in *.mkv ; do
  base="${mkv%mkv}"
  args=(-o "\"output/${base}mkv\"" "\"${mkv}\"")

  # look for subtitles with the same base name
  if [[ -f "${base}ass" ]]; then
    subs=("\"${base}ass\"")
  fi
  
  # look for eng folder
  if [[ -d "eng" ]]; then

    # look for eng audio with same base name
    for engfile in eng/*.mka ; do
      engFileBase=$(grep -F "${base}" <<<"$engfile")

      if [ -e "${engFileBase}" ]; then
        audio=("${audio[@]}" "\"${engFileBase}\"")
        break
      fi
    done

    # look for eng subtitles with same base name
    for engfile in eng/*.ass ; do
      engFileBase=$(grep -F "${base}" <<<"$engfile")

      if [ -e "${engFileBase}" ]; then
        subs=("${subs[@]}" "\"${engFileBase}\"")
        break
      fi
    done
  fi

  args=("${args[@]}" "${audio[@]}" "${subs[@]}")
  
  # look for fonts folder
  if [[ -d "fonts" ]]; then
    for font in fonts/*.ttf ; do
      args=("${args[@]}" "--attachment-mime-type application/x-truetype-font --attach-file \"${font}\"")
    done

    for font in fonts/*.otf ; do
      args=("${args[@]}" "--attachment-mime-type application/vnd.ms-opentype --attach-file \"${font}\"")
    done
  fi

  # create output file
  echo mkvmerge "${args[@]}" >> merge.bat
done