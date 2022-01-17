FROM openjdk:8-jre-slim

ENV VERSION ${VERSION:-5.3.1}
ENV EXIST_URL ${EXIST_URL:-https://github.com/eXist-db/exist/releases/download/eXist-${VERSION}/exist-installer-${VERSION}.jar}
ENV EXIST_HOME /opt/exist
ENV MAX_MEMORY ${MAX_MEMORY:-2048}
ENV EXIST_ENV ${EXIST_ENV:-development}
ENV EXIST_CONTEXT_PATH ${EXIST_CONTEXT_PATH:-/exist}
ENV EXIST_DATA_DIR ${EXIST_DATA_DIR:-/opt/exist/data}
ENV SAXON_JAR ${SAXON_JAR:-/opt/exist/lib/Saxon-HE-9.9.1-7.jar}

WORKDIR ${EXIST_HOME}

# adding expath packages to the autodeploy directory
ADD http://exist-db.org/exist/apps/public-repo/public/functx-1.0.1.xar ${EXIST_HOME}/autodeploy/docker
# adding the entrypoint script
COPY entrypoint.sh ${EXIST_HOME}/
RUN chmod +x ${EXIST_HOME}/entrypoint.sh


# adding some scripts/configuration files for fine tuning
COPY adjust-conf-files.xsl ${EXIST_HOME}/
COPY log4j2.xml ${EXIST_HOME}/

# main installation put into one RUN to squeeze image size
RUN apt-get update \
    && apt-get install -y curl zip expect cadaver mc \
    && echo "INSTALL_PATH=${EXIST_HOME}" > "/tmp/options.txt" \
    && echo "MAX_MEMORY=${MAX_MEMORY}" >> "/tmp/options.txt" \
    && echo "dataDir=${EXIST_DATA_DIR}" >> "/tmp/options.txt" \
    # install eXist-db
    # ending with true because java somehow returns with a non-zero after succesfull installing
    && curl -sL ${EXIST_URL} -o /tmp/exist.jar \
    && java -jar "/tmp/exist.jar" -options "/tmp/options.txt" || true \
    # remove JndiLookup class due to Log4Shell CVE-2021-44228 vulnerability
    && find ${EXIST_HOME} -name log4j-core-*.jar -exec zip -q -d {} org/apache/logging/log4j/core/lookup/JndiLookup.class \;

# download backups
RUN curl -sL https://github.com/alpheios-project/lexsvc/archive/master.zip -o /tmp/lexsvc.zip \
    && curl -sL https://github.com/alpheios-project/ml/archive/master.zip -o /tmp/ml.zip \
    && curl -sL https://github.com/alpheios-project/as/archive/master.zip -o /tmp/as.zip \
    && curl -sL https://github.com/alpheios-project/aut/archive/master.zip -o /tmp/aut.zip \
    && curl -sL https://github.com/alpheios-project/dod/archive/master.zip -o /tmp/dod.zip \
    && curl -sL https://github.com/alpheios-project/lsj/archive/master.zip -o /tmp/lsj.zip \
    && curl -sL https://github.com/alpheios-project/ls/archive/master.zip -o /tmp/ls.zip \
    && curl -sL https://github.com/alpheios-project/sal/archive/master.zip -o /tmp/sal.zip \
    && curl -sL https://github.com/alpheios-project/lan/archive/master.zip -o /tmp/lan.zip 

VOLUME ["${EXIST_DATA_DIR}"]

HEALTHCHECK --interval=60s --timeout=5s \
  CMD curl -Lf http://localhost:8080${EXIST_CONTEXT_PATH} || exit 1

CMD ["./entrypoint.sh"]

EXPOSE 8080
