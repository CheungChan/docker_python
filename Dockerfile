# Dockerfile github address: https://github.com/CheungChan/dev/blob/master/Dockerfile
# Dockerhub address:   https://hub.docker.com/r/cheungchan/dev/
FROM python:3.7.4
MAINTAINER chenzhang <1377699408@qq.com>
RUN mkdir workspace
WORKDIR workspace

# 公共部分
# 更改apt源
#COPY ./etc/apt.sources.list /etc/apt/sources.list
# 更改时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata
RUN apt-get install tzdata
ARG DEBIAN_FRONTEND=noninteractive

# 安装vim
RUN apt-get update
# 使用ARG 只有在build的时候有效, 使用ENV, 会持久化
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get install -y vim
RUN apt-get install -y htop
RUN apt-get install -y lrzsz

# Set the locale
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y locales

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8

# 安装openssh
RUN apt-get install -y openssh-server
COPY ./etc/sshd_config /etc/ssh/ssh_config
RUN echo 'root:root' |chpasswd
RUN echo "export VISIBLE=now" >> /etc/profile
RUN service ssh restart

# 项目私有部分

# 安装python依赖
COPY ./etc/pip.conf /root/.pip/pip.conf

# 安装一些基础的python扩展
#COPY ./etc/requirements.txt workspace/

EXPOSE 8022
ENTRYPOINT /usr/sbin/sshd && bash
# 启动命令如下:
# docker run --name python_c -itd cheungchan/python bash