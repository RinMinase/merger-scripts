#!/bin/bash

# an array for the arguments
declare -a args
declare -a audio
declare -a subs
rm -f merge.bat

# color codes
sh_b="\e[1;34m" # blue, welcome text
sh_g="\e[1;32m" # green, success text
sh_c="\e[1;36m" # cyan, info text
sh_r="\e[0m" # reset color

echo -e "${sh_b} Loading merge script generator ${sh_r}"

# loop over all MP4 files
echo -e "${sh_c} INFO ${sh_r} Looking for all mkv files present in the root folder"
for mkv in *.mkv ; do
  base="${mkv%mkv}"
  args=(--default-language en -o "\"output/${base}mkv\"" "\"${mkv}\"")
  subs=()
  audio=()

  # look for subtitles with the same base name
  echo -e "${sh_c} INFO ${sh_r} Looking for subtitles with the same base name"
  for subsFile in *.{ass,srt,mks} ; do
    subsFileBase=$(grep -F "${base}" <<<"$subsFile")

    if [ -e "${subsFileBase}" ]; then
      subs=("${subs[@]}" "\"${subsFileBase}\"")
      break
    fi
  done

  # look for audio with the same base name
  echo -e "${sh_c} INFO ${sh_r} Looking for audio with the same base name"
  for subsFile in *.mka ; do
    audFileBase=$(grep -F "${base}" <<<"$subsFile")

    if [ -e "${audFileBase}" ]; then
      audio=("${subs[@]}" "\"${audFileBase}\"")
      break
    fi
  done
  
  # look for eng folder
  echo -e "${sh_c} INFO ${sh_r} Checking if 'eng' folder is present"
  if [[ -d "eng" ]]; then
    echo -e "${sh_c} INFO ${sh_r} 'eng' folder is present"

    # look for eng audio with same base name
    echo -e "${sh_c} INFO ${sh_r} Looking for audio with the same base name"
    for engfile in eng/*.mka ; do
      engFileBase=$(grep -F "${base}" <<<"$engfile")

      if [ -e "${engFileBase}" ]; then
        audio=("${audio[@]}" "\"${engFileBase}\"")
        break
      fi
    done

    # look for eng subtitles with same base name
    echo -e "${sh_c} INFO ${sh_r} Looking for other subtitles with the same base name in 'eng' folder"
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
  echo -e "${sh_c} INFO ${sh_r} Looking for 'fonts' folder"
  if [[ -d "fonts" ]]; then
    for font in fonts/*.ttf ; do
      args=("${args[@]}" "--attachment-mime-type application/x-truetype-font --attach-file \"${font}\"")
    done

    for font in fonts/*.otf ; do
      args=("${args[@]}" "--attachment-mime-type application/vnd.ms-opentype --attach-file \"${font}\"")
    done
  fi

  # create output file
  echo -e "${sh_c} INFO ${sh_r} Appending to the output file"
  echo -e mkvmerge "${args[@]}" >> merge.bat
done

echo -e "${sh_g} SUCCESS ${sh_r} Finished creating output file"
sleep 2