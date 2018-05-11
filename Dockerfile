FROM maven:3.5-alpine

RUN apk add --update git tar

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
        MAVEN_HOME=/usr/share/maven \
        PATH=/usr/java/bin:/usr/local/apache-maven/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
        MANAGE_LOCAL_SOLR=true \
        MANAGE_LOCAL_HBASE=true \
        PATH=/opt/atlas/atlas-bin/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
        
WORKDIR /opt/atlas

RUN git clone http://git.apache.org/atlas.git -b master && \
        mvn clean install -DskipTests -Pdist,embedded-hbase-solr -f ./atlas/pom.xml && \
        mkdir -p atlas-bin && \
        tar xzf /opt/atlas/atlas/distro/target/*bin.tar.gz --strip-components 1 -C /opt/atlas/atlas-bin && \
        rm -rf /opt/atlas/atlas && \
        rm -rf /root/.m2
        
EXPOSE 21000

CMD ["/bin/bash", "-c", "/opt/atlas/atlas-bin/bin/atlas_start.py; tail -fF /opt/atlas/atlas-bin/logs/application.log"]
