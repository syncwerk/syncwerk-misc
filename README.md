# syncwerk-misc

## syncwerk-find-0-byte-files-replace-with-latest-SFConfict-version

**Caution:** BETA script - Make backups before executing script

**About:** Finds 0-byte files and replaces it with the latest corresponding SFConflict file

**Limitations:** Does not support files without extension.

### Install
The script can be used on Windows, Linux and possibly macOS (untested).

#### Windows
Install MSYS2 from http://www.msys2.org/. Run the following commands in the MSYS2 shell.

**Download**
```
mkdir -p /usr/local/bin
wget https://raw.githubusercontent.com/syncwerk/syncwerk-misc/master/syncwerk-find-0-byte-files-replace-with-latest-SFConfict-version -O /usr/local/bin/syncwerk-find-0-byte-files-replace-with-latest-SFConfict-version

chmod +x /usr/local/bin/syncwerk-find-0-byte-files-replace-with-latest-SFConfict-version
```

**Usage:** Change into directory which you want to scan for 0-byte files recursively. Then call `syncwerk-find-0-byte-files-replace-with-latest-SFConfict-version`
```
cd /c/Users/jdoe/Syncwerk/My\ Library
syncwerk-find-0-byte-files-replace-with-latest-SFConfict-version
```

## syncwerk-find-and-move-duplicates

**Caution:** BETA script - Make backups before executing script

**About:** Finds duplicate files within each directory by comparing the md5 checksums. Duplicate files are then moved to a sub-folder named `syncwerk-found-duplicates`. This script is mainly intended to find duplicate "SFConflict" files but will also find other duplicate files.

### Install
The script can be used on Windows, Linux and possibly macOS (untested).

#### Windows
Install MSYS2 from http://www.msys2.org/. Run the following commands in the MSYS2 shell.

**Download**
```
mkdir -p /usr/local/bin
wget https://raw.githubusercontent.com/syncwerk/syncwerk-misc/master/syncwerk-find-and-move-duplicates -O /usr/local/bin/syncwerk-find-and-move-duplicates

chmod +x /usr/local/bin/syncwerk-find-and-move-duplicates
```

**Usage:** Change into directory which you want to scan for duplicates files recursively. Then call `syncwerk-find-and-move-duplicates`
```
cd /c/Users/jdoe/Syncwerk/My\ Library
syncwerk-find-and-move-duplicates
```

## Hotfix - Purge file-locking on servers which experience increased syncing issues

**Download**
```
wget https://raw.githubusercontent.com/syncwerk/syncwerk-misc/master/syncwerk-purge-file-locks -O /usr/local/sbin/syncwerk-purge-file-locks

chmod 700 /usr/local/sbin/syncwerk-purge-file-locks
```

**Run manually**
```
syncwerk-purge-file-locks
```

**Run automatically**

Setup cronjob to purge file-locks continously. 

## Hotfix - Enable Syncwerk office preview on Debian Stretch
```
cd /usr/src/
wget https://github.com/syncwerk/syncwerk-misc/blob/master/syncwerk-python-uno_4.3.3-2+deb8u7_amd64.tgz?raw=true -O syncwerk-python-uno_4.3.3-2+deb8u7_amd64.tgz
tar xzf syncwerk-python-uno_4.3.3-2+deb8u7_amd64.tgz
cp -a  syncwerk-python-uno_4.3.3-2+deb8u7_amd64/usr/* /usr/
```
