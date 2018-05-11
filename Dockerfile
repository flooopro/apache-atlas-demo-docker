FROM ubuntu:18.04

RUN apt-get update && apt-get install -y git python openjdk-8-jdk maven

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
        MAVEN_HOME=/usr/share/maven \
        PATH=/usr/java/bin:/usr/local/apache-maven/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
        MANAGE_LOCAL_SOLR=true \
        MANAGE_LOCAL_HBASE=true \
        PATH=/root/atlas-bin/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
        
WORKDIR /root

RUN git clone http://git.apache.org/atlas.git -b master && \
        mvn clean install -DskipTests -Pdist,embedded-hbase-solr -f ./atlas/pom.xml && \
        mkdir -p atlas-bin && \
        tar xzf /root/atlas/distro/target/*bin.tar.gz --strip-components 1 -C /root/atlas-bin && \
        rm -rf /root/atlas && \
        rm -rf /root/.m2
        
EXPOSE 21000

CMD ["/bin/bash", "-c", "/root/atlas-bin/bin/atlas_start.py; tail -fF /root/atlas-bin/logs/application.log"]
