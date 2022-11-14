# MKV-related scripts

These are scripts used to modify MKV-related files. You may use them as references.

## Pre-requisites:
- [MKVToolNix](https://mkvtoolnix.download/source.html#download)

## File information:
`merge-generator.sh` - generates a `merge.bat` to merge video, audio and subtitles

`merger.sh` - an improved version of `merge-generator.sh` which process the files, merging the video, audio and subtitles directly while running

`modify-default-subs.sh` - changes the default subtitles using mkvpropinfo id tracks

`remove-thumbs.sh` - removes any images (jpeg & png) attached to the mkv which are usually used as cover photos