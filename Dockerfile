FROM ibmcom/swift-ubuntu:latest

MAINTAINER Jarrod Parkes <jarrod@udacity.com>

RUN apt-get update; \
    apt-get dist-upgrade -y; \
    apt-get install -y librtmp0 login passwd

WORKDIR /app
