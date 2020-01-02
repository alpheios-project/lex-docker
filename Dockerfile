FROM openjdk:7u131-jdk
MAINTAINER Alpheios Project

RUN echo "deb [check-valid-until=no] http://cdn-fastly.deb.debian.org/debian jessie main" > /etc/apt/sources.list.d/jessie.list
RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list
RUN apt-get -o Acquire::Check-Valid-Until=false update

RUN apt-get install -y curl expect cadaver

WORKDIR /tmp
RUN curl -LO http://downloads.sourceforge.net/exist/Stable/2.2/eXist-db-setup-2.2.jar
RUN curl -L -o lexsvc.zip https://github.com/alpheios-project/lexsvc/archive/master.zip
RUN curl -L -o stg.zip https://github.com/alpheios-project/stg/archive/master.zip
RUN curl -L -o as.zip https://github.com/alpheios-project/as/archive/master.zip
RUN curl -L -o aut.zip https://github.com/alpheios-project/aut/archive/master.zip
RUN curl -L -o dod.zip https://github.com/alpheios-project/dod/archive/master.zip
RUN curl -L -o lsj.zip https://github.com/alpheios-project/lsj/archive/master.zip
RUN curl -L -o ls.zip https://github.com/alpheios-project/ls/archive/master.zip
RUN curl -L -o ml.zip https://github.com/alpheios-project/ml/archive/master.zip
RUN curl -L -o sal.zip https://github.com/alpheios-project/sal/archive/master.zip
RUN curl -L -o lan.zip https://github.com/alpheios-project/lan/archive/master.zip
ADD exist-setup.cmd /tmp/exist-setup.cmd
RUN expect -f exist-setup.cmd
RUN rm eXist-db-setup-2.2.jar exist-setup.cmd

EXPOSE 8080 8443
ENV EXIST_HOME /opt/exist
WORKDIR /opt/exist
#ADD alpheios /tmp/alpheios
ADD exist-startup.sh /tmp/exist-startup.sh
RUN /tmp/exist-startup.sh

CMD tools/wrapper/bin/exist.sh console

