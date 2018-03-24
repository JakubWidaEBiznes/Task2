FROM ubuntu:16.04

ENV SCALA_VERSION 2.12.5
ENV SBT_VERSION 1.1.1


#installing additional prerequisites
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget && \
  rm -rf /var/lib/apt/lists/*

#installing mysql server
RUN \
  apt-get update \
  apt-get install mysql-server \
  mysql_secure_installation

#installing java
RUN \
  apt-get update \
  apt-get install default-jre -y \
  add-apt-repository ppa:webupd8team/java \
  apt-get update \
  apt-get install oracle-java8-installer -y

#scala
RUN \
  curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo "export PATH=~/scala-$SCALA_VERSION/bin:$PATH" >> /root/.bashrc

#sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  sbt sbtVersion

COPY /task2 /home
WORKDIR /home/task2

#exposing port
EXPOSE 80
