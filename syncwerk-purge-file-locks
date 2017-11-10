#!/bin/bash
set -ex
date
echo "Selecting content from syncwerk-db.FileLocks"
mysql -e 'select * from `syncwerk-db`.`FileLocks`;'
echo "Deleting content from syncwerk-db.FileLocks"
mysql -e 'delete from `syncwerk-db`.`FileLocks`;'


echo "Selecting content from syncwerk-db.FileLockTimestamp"
mysql -e 'delete from `syncwerk-db`.`FileLockTimestamp`;'
echo "Deleting content from syncwerk-db.FileLockTimestamp"
mysql -e 'select * from `syncwerk-db`.`FileLockTimestamp`;'
