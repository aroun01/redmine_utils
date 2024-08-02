#!/bin/bash


LOG="/var/log/backup_redmine.log"
DPASS="6yhnghjH^"
DUSER="root"
BPATH="/home/backups"
RMPATH="/var/www/html"

#Create backup path
mkdir -p $BPATH &> /dev/null

#Clean logs
rm -rf $RMPATH/*/log/*

#backup mysql db
/usr/bin/mysqldump -u $DUSER -p$DPASS --all-databases | gzip > $BPATH/redmine_dababase_`date +%Y-%m-%d`.gz ; | tee -a $LOG ; 111cd $BPATH


#Create archive
/usr/bin/zip -r redmine_full_backup_`date +%d-%m-%Y`.zip  $RMPATH  $BPATH/redmine_dababase_`date +%Y-%m-%d`.gz -x '*.log' -x '*/log' | tee -a $LOG

#Clean temp files
rm $BPATH/redmine_dababase_`date +%Y-%m-%d`.gz

#Clean older arhives
find $BPATH -type f -mtime +$OLDER -print0 | xargs -0 rm -f | tee -a $LOG
