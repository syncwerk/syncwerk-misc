#!/bin/bash
# Uncomment for verbose logging
#set -x

echo $(date) - Start | tee -a syncwerk-replaced-empty-files.log

# Enter each directory recursivly
find "$(pwd)" -type d ! -name "syncwerk-found-duplicates" | while read dir ; do
  # Check if directory contains 0-byte files
  find "${dir}" -maxdepth 1 -type f -size 0 | while read emptyfile ; do
    # Check if 0-byte file has a corresponding SFConflict version
    conflictfile="$(ls -t "$(echo $(dirname "${emptyfile}")/$(basename "${emptyfile%.*}"))"*SFConflict*@* 2>/dev/null | head -1)"
    # If corresponding SFConflict file exists, continue
    if [[ -n "${conflictfile}" ]] ; then
      # Log changes
      echo $(date) - Replacing empty file ${emptyfile} with ${conflictfile} | tee -a syncwerk-replaced-empty-files.log
      # Replace 0-byte file with the latest found SFConflict file
      mv "${conflictfile}" "${emptyfile}"
    fi
  done

done

echo $(date) - End | tee -a syncwerk-replaced-empty-files.log

echo Check syncwerk-replaced-empty-files.log for applied changes
