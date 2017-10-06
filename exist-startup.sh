#!/bin/sh

# make sure exist is good and stopped and stale pid file gone
/opt/exist/tools/wrapper/bin/exist.sh stop
# make sure exist is started
/opt/exist/tools/wrapper/bin/exist.sh start
# restore the apps
/opt/exist/bin/backup.sh -u admin -p admin -r /tmp/lexsvc.zip
/opt/exist/bin/backup.sh -u admin -p admin -r /tmp/stg.zip
/opt/exist/bin/backup.sh -u admin -p admin -r /tmp/ls.zip
/opt/exist/bin/backup.sh -u admin -p admin -r /tmp/lsj.zip
/opt/exist/bin/backup.sh -u admin -p admin -r /tmp/aut.zip
/opt/exist/bin/backup.sh -u admin -p admin -r /tmp/as.zip
/opt/exist/bin/backup.sh -u admin -p admin -r /tmp/dod.zip
/opt/exist/bin/backup.sh -u admin -p admin -r /tmp/ml.zip
/opt/exist/bin/backup.sh -u admin -p admin -r /tmp/lan.zip
/opt/exist/bin/backup.sh -u admin -p admin -r /tmp/sal.zip

# make sure exist is good and stopped and stale pid file gone
/opt/exist/tools/wrapper/bin/exist.sh stop
