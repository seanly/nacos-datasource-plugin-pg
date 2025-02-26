ARG VERSION=2.4.1-2
FROM docker.opsbox.dev/seanly/toolset:openjdk-8u372-b07-2 AS build

WORKDIR /code/pg
COPY ./ ./

RUN <<EOF
rsync -av /maven-wrapper/ ./
mkdir -p /root/.m2/
cat settings.xml.tmpl | envsubst > /root/.m2/settings.xml

./mvnw install:install-file -Dfile=./libs/postgresql-42.7.5.jar \
    -DgroupId=org.postgresql -DartifactId=postgresql -Dversion=42.7.5 \
    -Dpackaging=jar

./mvnw -B -e -U -DskipTests clean install
cp -r target/*.jar libs/
EOF

FROM docker.opsbox.dev/seanly/appset:nacos-${VERSION}

LABEL maintainer="seanly <seanly@opsbox.dev>"
COPY --from=build /code/pg/libs/ /home/nacos/plugins/
COPY ./package/bake/conf/application.properties /home/nacos/conf/application.properties

EXPOSE 8848

ENTRYPOINT ["bash", "bin/start.sh"]