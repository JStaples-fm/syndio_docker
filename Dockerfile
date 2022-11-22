FROM amazoncorretto:11-alpine-jdk

# Install packages
RUN apk update && apk add --update --no-cache py3-pip

# Install AWSCLI
RUN pip install --upgrade pip && \
    pip install --upgrade awscli

#Parameterise necessary variables
ENV ENTRY_JAR=elastic_in-0.0.1-SNAPSHOT.jar JAR_MEM=128
ARG ENTRY_PASSWORD
#Check variables are correct
RUN echo "ENTRY_JAR value : ${ENTRY_JAR} + JAR_MEM value : ${JAR_MEM}"

COPY ${ENTRY_JAR} app.jar

#Necessary steps as ENTRYPOINT refuses to resolve variables
RUN echo "#!/bin/bash \n java", "-Xmx${JAR_MEM}m", "-jar", "app.jar", "--spring.profiles.active=uat", "--jasypt.encryptor.password=${ENTRY_PASSWORD}" > ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]