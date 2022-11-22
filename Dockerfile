FROM openjdk:latest
ENV ENTRY_JAR=elastic_in-0.0.1-SNAPSHOT.jar JAR_MEM=128 JAR_PASSWORD=arn:aws:secretsmanager:eu-west-2:651762338902:secret:syndio/password-GtTtxA password=default
RUN echo "ENTRY_JAR value : ${ENTRY_JAR} + JAR_MEM value : ${JAR_MEM} + JAR_PASSWORD value : ${JAR_PASSWORD}"
COPY ${ENTRY_JAR} app.jar
RUN echo "PW value : ${password}"
#Necessary steps as ENTRYPOINT refuses to resolve variables
RUN echo "#!/bin/bash \n java", "-Xmx${JAR_MEM}m", "-jar", "app.jar", "--spring.profiles.active=uat", "--jasypt.encryptor.password=${JAR_PASSWORD}" > ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]