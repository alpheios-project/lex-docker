#!/bin/sh

# make sure exist is good and stopped and stale pid file gone
/opt/exist/tools/wrapper/bin/exist.sh stop
# make sure exist is started
/opt/exist/tools/wrapper/bin/exist.sh start
# restore the apps
/opt/exist/bin/backup.sh -u admin -p admin -r /tmp/lexsvc.zip
/opt/exist/bin/backup.sh -u admin -p admin -r /tmp/stg.zip

# make sure exist is good and stopped and stale pid file gone
/opt/exist/tools/wrapper/bin/exist.sh stop
