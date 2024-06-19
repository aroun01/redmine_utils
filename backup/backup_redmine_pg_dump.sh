#!/bin/bash


LOG="/var/log/backup_redmine.log"
DPASS="YOUR_PASSWORD_PG_DATABASE"
DUSER="YOUR_USER_PG_DATABASE"
DBBASE="YOUR_DATABASE_PG"
BPATH="/mnt/nfs/backups/"
RMPATH="/var/www/html/redmine/"
OLDER=60

#############################


touch $LOG &> /dev/null
mkdir -p $BPATH &> /dev/null


#rvm list
cd $RMPATH
rvm list > rvm.list

#gem list
gem list --local > gem.list


#backup packages list
dpkg --get-selections > packages.lst



#backup pg
cd $RMPATH
PGPASSWORD=$DPASS /usr/bin/pg_dump $DBBASE -U $DUSER -h localhost -Fc --file=redmine_dababase_`date +%Y-%m-%d`.dump

#backup files
zip -r $BPATH/redmine_backup_`date +%Y-%m-%d`.zip $RMPATH
#
sleep 4
#Move files backup
#mv $RMPATH*gz  $BPATH

#remove temporary files and older backup
#rm $BPATH/redmine_dababase_`date +%Y-%m-%d`.gz
rm $RMPATH/redmine_dababase_`date +%Y-%m-%d`.dump ; rm $RMPATH/rvm.list ; rm $RMPATH/gem.list ; rm $RMPATH/packages.lst
find $BPATH -type f -mtime +$OLDER -print0 | xargs -0 rm -f | tee -a $LOG
