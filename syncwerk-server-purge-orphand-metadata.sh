#!/bin/bash
#
# This script purges orphaned file system metadata from the Syncwerk server
#
# In rare cases the Syncwerk file system metadata my occupy a multitude of the libraries
# storage blocks. Use this script to purge these orphand metadata files and free storage space.
#
# This script was created to solve an issue where the metadata grew up to 340 GB within 3 years.
# Oddly enough the corresponding library size was less then 250 MB and included roughly 2000 files.
# Due to high frequent updates the libraries metadata grew and caused this hugh waste.
#
# Todo: Review server code to avoid this waste of storage space
#
# Uncomment for verbose logging
# set -x


# Vars
DATABASE="syncwerk-db" # Database that contains latest Syncwerk file server commit
SYNCWERKROOT="/opt/syncwerk" # Current active Syncwerk server location
LOG="${SYNCWERKROOT}/$(basename ${0}).log"
TIMESTAMP="$(date +%s)"


function run {
# Set repo id
REPOID=${1}

# Start
cat << EOF
$(date) - Start

Usage: $(du -hs ${SYNCWERKROOT}/syncwerk-data/storage/fs/${REPOID})
Files: $(find ${SYNCWERKROOT}/syncwerk-data/storage/fs/${REPOID} -type f | wc -l)
EOF


# Change working directory
cd ${SYNCWERKROOT}


# Ensure library is in an consistent state
sudo -u syncwerk ./syncwerk-server-latest/fsck.sh --repair ${REPOID}


# Stop Syncwerk Server
syncwerk-server-stop || /etc/init.d/syncwerk-server stop


# Get latest commit id
COMMITID=$(mysql -sNe "select commit_id from \`${DATABASE}\`.\`Branch\` where \`repo_id\` = '${REPOID}' ;")


# Get latest root fs
ROOTFSID=$(grep -o "root_id.*repo_cat" syncwerk-data/storage/commits/${REPOID}/$(echo ${COMMITID} | sed 's/.\{2\}/&\//') | awk -F'"' '{ print $3 }')


# Relocate old repo file system metadata
sudo -u syncwerk mv syncwerk-data/storage/fs/${REPOID} syncwerk-data/storage/fs/${REPOID}.bak.${TIMESTAMP}


# Recreate previous folder structure
ls syncwerk-data/storage/fs/${REPOID}.bak.${TIMESTAMP} | while read DIR ; do sudo -u syncwerk mkdir -p syncwerk-data/storage/fs/${REPOID}/${DIR} ; done


# Copy root fs commit from old file system metadata
sudo -u syncwerk cp syncwerk-data/storage/fs/${REPOID}.bak.${TIMESTAMP}/$(echo ${ROOTFSID} | sed 's/.\{2\}/&\//') syncwerk-data/storage/fs/${REPOID}/$(echo ${ROOTFSID} | sed 's/.\{2\}/&\//')


# Run fsck to extract missing file system metadata commits and build temporary file copy script
sudo -u syncwerk echo "cd ${SYNCWERKROOT}" > copyfiles.sh
sudo -u syncwerk ./syncwerk-server-latest/fsck.sh ${REPOID} | grep missing | awk '{ print $5 }' | sed 's/.\{2\}/&\ /' | while read FILE ; do echo ${FILE} | awk "{ print \"cp syncwerk-data/storage/fs/${REPOID}.bak.${TIMESTAMP}/\"\$1\"/\"\$2 \" syncwerk-data/storage/fs/${REPOID}/\"\$1\"/\"\$2 }" ;  done >> copyfiles.sh


# Execute file copy script
sudo -u syncwerk bash copyfiles.sh


# Check repos file system consistency
sudo -u syncwerk ./syncwerk-server-latest/fsck.sh ${REPOID}


# Start Syncwerk server
syncwerk-server-start || /etc/init.d/syncwerk-server start


# Cleanup if no errors
rm copyfiles.sh
# rm copyfiles.sh syncwerk-data/storage/fs/${REPOID}.bak.${TIMESTAMP}


# Finished
cat << EOF
$(date) - Finished

Usage: $(du -hs ${SYNCWERKROOT}/syncwerk-data/storage/fs/${REPOID})
Files: $(find ${SYNCWERKROOT}/syncwerk-data/storage/fs/${REPOID} -type f | wc -l)
EOF
}


mysql -sNe "select repo_id from \`syncwerk-db\`.\`Branch\`;" | while read REPO ; do run ${REPO} ; done | tee -a ${LOG}
