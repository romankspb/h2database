FROM openjdk:11

MAINTAINER Roman Kravtsov

ENV H2_DIST https://h2database.com/h2-2019-10-14.zip

RUN mkdir -p /opt/h2/bin /opt/h2/data \
    && curl ${H2_DIST} -o /tmp/h2.zip \
    && unzip /tmp/h2.zip -d /tmp/ \
    && cp /tmp/h2/bin/*.jar /opt/h2/bin/ \
    && rm -rf /tmp/h2*

COPY h2.server.properties /opt/h2/.h2.server.properties

EXPOSE 8080 1521 5435

WORKDIR /opt/h2

CMD java -cp /opt/h2/bin/h2*.jar org.h2.tools.Server \
    -web -webAllowOthers -webPort 8080 \
    -tcp -tcpAllowOthers -tcpPort 1521 \
    -pg -pgAllowOthers -pgPort 5435 \
    -properties /opt/h2 \
    -baseDir /opt/h2/data \
    -ifNotExists ${H2_OPTIONS}
