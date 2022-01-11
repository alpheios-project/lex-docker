#!/bin/bash

SAXON="java ${JAVA_OPTIONS} -jar ${SAXON_JAR} env=${EXIST_ENV} context_path=${EXIST_CONTEXT_PATH} default_app_path=${EXIST_DEFAULT_APP_PATH} -xsl:${EXIST_HOME}/adjust-conf-files.xsl"

##############################################
# function for adjusting configuration files for eXist versions >= 5
##############################################
function adjust_config_files_eXist5 {
${SAXON} -s:${EXIST_HOME}/etc/conf.xml -o:/tmp/conf.xml
${SAXON} -s:${EXIST_HOME}/etc/jetty/webapps/exist-webapp-context.xml -o:/tmp/exist-webapp-context.xml
${SAXON} -s:${EXIST_HOME}/etc/webapp/WEB-INF/controller-config.xml -o:/tmp/controller-config.xml
${SAXON} -s:${EXIST_HOME}/etc/webapp/WEB-INF/web.xml -o:/tmp/web.xml
${SAXON} -s:${EXIST_HOME}/etc/log4j2.xml -o:/tmp/log4j2.xml

# copying modified configuration files from tmp folder to original destination
mv /tmp/conf.xml ${EXIST_HOME}/etc/conf.xml
mv /tmp/exist-webapp-context.xml ${EXIST_HOME}/etc/jetty/webapps/exist-webapp-context.xml
mv /tmp/controller-config.xml ${EXIST_HOME}/etc/webapp/WEB-INF/controller-config.xml
mv /tmp/web.xml ${EXIST_HOME}/etc/webapp/WEB-INF/web.xml
mv /tmp/log4j2.xml ${EXIST_HOME}/etc/log4j2.xml
}

##############################################

adjust_config_files_eXist5

echo "========== STARTING"
${EXIST_HOME}/bin/startup.sh &

# we need this to prevent from Connection refused error - be sure that existdb is startup as a service
sleep 1m

# restore backups

echo "========== RESTORING 1"
/opt/exist/bin/backup.sh -u admin -p '$adminPasswd' -r /tmp/lexsvc.zip

echo "========== RESTORING 2"
/opt/exist/bin/backup.sh -u admin -p '$adminPasswd' -r /tmp/ml.zip

echo "========== RESTORING 3"
/opt/exist/bin/backup.sh -u admin -p '$adminPasswd' -r /tmp/as.zip

echo "========== RESTORING 4"
/opt/exist/bin/backup.sh -u admin -p '$adminPasswd' -r /tmp/aut.zip

echo "========== RESTORING 5"
/opt/exist/bin/backup.sh -u admin -p '$adminPasswd' -r /tmp/dod.zip

echo "========== RESTORING 6"
/opt/exist/bin/backup.sh -u admin -p '$adminPasswd' -r /tmp/lsj.zip

echo "========== RESTORING 7"
/opt/exist/bin/backup.sh -u admin -p '$adminPasswd' -r /tmp/ls.zip

echo "========== RESTORING 8"
/opt/exist/bin/backup.sh -u admin -p '$adminPasswd' -r /tmp/sal.zip

echo "========== RESTORING 9"
/opt/exist/bin/backup.sh -u admin -p '$adminPasswd' -r /tmp/lan.zip

echo "========== RESTORING Finish"
exec tail -f /dev/null
