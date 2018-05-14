FROM ubuntu:18.04
WORKDIR /root
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV MAVEN_HOME /usr/share/maven
ENV PATH /root/atlas-bin/bin:/usr/java/bin:/usr/local/apache-maven/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV MANAGE_LOCAL_SOLR true
ENV MANAGE_LOCAL_HBASE true
RUN apt-get update && \
        apt-get install -y git python openjdk-8-jdk maven lsof net-tools && \
        apt-get upgrade -y && \
        rm -rf /var/lib/apt/lists/* && \
        mkdir -p /root/atlas-bin
RUN git clone http://git.apache.org/atlas.git -b master && \
        mvn clean install -DskipTests -Pdist,embedded-hbase-solr -f ./atlas/pom.xml && \
        tar xzf /root/atlas/distro/target/*bin.tar.gz --strip-components 1 -C /root/atlas-bin && \
        rm -rf /root/.m2 && \
        rm -rf /root/atlas
EXPOSE 21000
CMD ["/bin/bash", "-c", "/root/atlas-bin/bin/atlas_start.py; tail -fF /root/atlas-bin/logs/application.log"]
