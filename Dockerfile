FROM amazoncorretto:11-alpine-jdk

# Install packages
RUN apk update && apk add --update --no-cache py3-pip

# Install AWSCLI
RUN pip install --upgrade pip && \
    pip install --upgrade awscli

ENV ENTRY_JAR=elastic_in-0.0.1-SNAPSHOT.jar JAR_MEM=128 JAR_PASSWORD=syndio
RUN echo "ENTRY_JAR value : ${ENTRY_JAR} + JAR_MEM value : ${JAR_MEM} + PW value : ${password}"
COPY ${ENTRY_JAR} app.jar

ARG HELLO
RUN echo "Hello value : ${HELLO}"

# RUN aws secretsmanager get-secret-value --secret-id ${JAR_PASSWORD} --region eu-west-1
# RUN aws secretsmanager get-secret-value --secret-id syndio | jq --raw-output .SecretString | jq -r ."password"

#Necessary steps as ENTRYPOINT refuses to resolve variables
RUN echo "#!/bin/bash \n java", "-Xmx${JAR_MEM}m", "-jar", "app.jar", "--spring.profiles.active=uat", "--jasypt.encryptor.password=${password}" > ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]