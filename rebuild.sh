#!/usr/bin/env bash


version=$1
if test -z "$version"
then
    echo "please input version number"
    exit
fi
image_name='cheungchan/python'
container_name='python_container'

echo "删除 ${container_name} 容器"
docker rm $container_name

echo "构建镜像 $image_name:$version"
docker build --rm -t "$image_name:$version" .

echo "启动容器 $container_name"
docker run --name $container_name -itd "$image_name:$version" bash

echo '提交镜像'
docker commit -a "chenzhang" -m '升级到$version' $container_name  "$image_name:$version"
docker commit -a "chenzhang" -m '升级到$version' $container_name  "$image_name:latest"

echo '推送镜像'
docker push "$image_name:$version"
docker push "$image_name:latest"

echo "rebuild $image_name:$version 完成"