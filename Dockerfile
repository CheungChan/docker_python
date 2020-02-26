FROM python:3.8.1
MAINTAINER chenzhang <1377699408@qq.com>

COPY ./etc/pip.conf /root/.pip/pip.conf
RUN mkdir workspace
WORKDIR workspace

# 更改时区
ENV TZ=Asia/Shanghai
RUN apt-get update
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata
RUN apt-get install tzdata
# 使用ARG 只有在build的时候有效, 使用ENV, 会持久化
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y locales vim htop

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8
RUN echo "Asia/Shanghai" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# 安装openssh
RUN apt-get install -y openssh-server
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN echo 'Port 22' >> /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin prohibit-password/# PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
RUN echo 'root:root' |chpasswd
RUN echo "export VISIBLE=now" >> /etc/profile
RUN /etc/init.d/ssh restart
RUN /usr/sbin/sshd
RUN pip install --upgrade pip
EXPOSE 22
CMD bash