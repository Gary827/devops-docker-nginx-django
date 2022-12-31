FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y software-properties-common build-essential libfreetype-dev libfreetype6 libfreetype6-dev nfs-common locales && \
    apt-get update && \
    apt-get -y install tzdata python3 python3-pip libmysqlclient-dev libgdal-dev nginx libssl-dev libcrypto++-dev git && \
    apt-get update && apt-get install -y xvfb

RUN TZ=Asia/Taipei \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata \
    && locale-gen en_US.UTF-8

ENV PYTHONUNBUFFERED 1
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

WORKDIR /
COPY dj32 /dj32

WORKDIR /dj32
RUN pip3 install -r requirements.txt

COPY dj32.conf /etc/nginx/conf.d/dj32.conf
COPY uwsgi_params /etc/nginx/
# COPY probes /probes

# 使用ENTRYPOINT指令是直接在Container的環境中下指令，不是在運行Docker的本機環境喔 !
ENTRYPOINT bash -c "service nginx start && uwsgi --ini uwsgi.ini"
