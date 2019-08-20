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
RUN apt-get install -y vim
# 安装htop
RUN apt-get install -y htop
RUN apt-get install -y lrzsz
RUN touch /var/log/nothing.log
# 安装openssh
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN mkdir /root/.ssh
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN echo "export VISIBLE=now" >> /etc/profile
RUN service ssh restart

# 项目私有部分

# 安装python依赖
COPY ./etc/pip.conf /root/.pip/pip.conf

# 安装一些基础的python扩展
#COPY ./etc/requirements.txt workspace/
#CMD tail -f /var/log/nothing.log

EXPOSE 22
ENTRYPOINT /usr/sbin/sshd && bash
# 启动命令如下:
# docker run --name python_c -itd cheungchan/python bash