FROM openjdk:11 AS BUILD_IMAGE
RUN apt update && apt install maven -y
COPY ./ vprofile-project
RUN cd vprofile-project &&  mvn install 

FROM tomcat:9-jre11
LABEL "Project"="Vprofile"
LABEL "Author"="Imran"
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=BUILD_IMAGE vprofile-project/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
WORKDIR /usr/local/tomcat/
VOLUME /usr/local/tomcat/webapps
FROM mysql:5.7.25
ENV MYSQL_ROOT_PASSWORD="vprodbpass"
MYSQL_DATABASE="accounts"

ADD db_backup.sql docker-entrypoint-init.d/db_backup.sql

FROM nginx
LABEL "project=vprofile"
RUN rm -rf /etc/nginx/conf.d/default.conf
COPY nginvproapp.conf /etc/nginx/conf.d/vproapp.conf

