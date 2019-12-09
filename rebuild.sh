#!/usr/bin/env bash

version=$1
if test -z "$version"; then
  echo "please input version number"
  exit
fi
image_name='cheungchan/python'

echo "构建镜像 $image_name:$version"
docker build -t "$image_name:$version" .

echo '推送镜像'
docker push "$image_name:$version"
docker push "$image_name:latest"

echo "rebuild $image_name:$version 完成"
