# 基于debian的最新python环境

### 如果需要修改
1. 修改代码
2. `sh rebuild.sh python` 最新版本号(`3.7.4`)

## 启动
```bash
# 暴露ssh端口, 可用于远程调试
docker run --name python_c -p 8022:22 -itd cheungchan/python bash
```