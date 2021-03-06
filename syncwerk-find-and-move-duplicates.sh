#!/bin/bash
# Uncomment for verbose logging
# set -x

touch syncwerk-find-and-move-duplicates.log


# Enter each directory recursivly. Check if it contains duplicate files by calculating and comparing the inlcuded files md5 checksums. Saving result to dups_tmp0.txt
find "$(pwd)" -type d ! -name "syncwerk-found-duplicates" | while read dir ; do

  find "${dir}" -maxdepth 1 -type f ! -size 0 -exec md5sum '{}' + | sort | uniq --all-repeated=separate -w 33 > dups_tmp0.txt

  # Retrieving uniq md5 checksum from dups_tmp0.txt. Grepping the corresponding files for each checksum. Saving result to dups_tmp1.txt
  awk '{ print $1 }' dups_tmp0.txt | sort | uniq | sed '/^\s*$/d' | while read dups ; do grep ${dups} dups_tmp0.txt | cut -c 35- > dups_tmp1.txt

  # Initialize dups_tmp2.txt. Needs to be empty...
  echo -n > dups_tmp2.txt

  # Iterate through dups_tmp1.txt and calculate path length of each file. Save result to dups_tmp2.txt.
  cat dups_tmp1.txt | while read dupfile ; do
    echo ${dupfile} | awk '{ print length, $0 }' >> dups_tmp2.txt
  done

  # Remove any empty lines from dups_tmp2.txt
  sed -i '/^\s*$/d' dups_tmp2.txt

  # Sort by numbers and save result to dups_tmp3.txt
  sort -n dups_tmp2.txt > dups_tmp3.txt

  # Log which file we are keeping. FYI: We are keeping the file with the shortes path/name
   echo $(date) - Original - $(cat dups_tmp3.txt | head -n +1 | cut -c 5-) | tee -a syncwerk-find-and-move-duplicates.log

  # Move duplicate files to subfolder "duplicates" within the found directory. Log actions...
  cat dups_tmp3.txt | tail -n +2 | cut -c 5- | while read delfile ; do
    echo $(date) - Duplicate - /${delfile} moved to ${dir}/syncwerk-found-duplicates/ ; mkdir -p "${dir}/syncwerk-found-duplicates" ; mv /"${delfile}" "${dir}/syncwerk-found-duplicates/" ; done | tee -a syncwerk-find-and-move-duplicates.log
  done

  # Cleanup: Delete temp files
  rm dups*.txt

done

echo Check syncwerk-find-and-move-duplicates.log for applied changes
