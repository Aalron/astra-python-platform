#!/bin/bash

if [ ! -f "docker-compose.yml" ]; then
    echo "错误：当前目录未找到 docker-compose.yml 文件，请在正确目录执行脚本"
    exit 1
fi

echo "警告：此操作将彻底删除 docker-compose.yml 定义的所有资源，包括："
echo "- 所有相关容器"
echo "- 所有相关网络" 
echo "- 所有相关数据卷（删除后不可恢复）"
echo "- 所有相关镜像"
echo
echo "即将删除的资源："

# 显示 docker-compose 定义的资源
echo "项目服务："
docker compose config --services

echo
echo "相关镜像："
docker compose images

echo
read -p "是否继续？此操作不可撤销！(y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "操作已取消"
    exit 0
fi

echo "开始彻底卸载..."

# 停止并删除所有容器、网络、卷
echo "步骤1: 停止并删除容器、网络、卷..."
docker compose down -v

# 获取项目名称（用于删除相关镜像）
PROJECT_NAME=$(basename "$PWD" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]//g')

# 删除所有相关镜像
echo "步骤2: 删除相关镜像..."
images=$(docker compose images -q)
if [ -n "$images" ]; then
    echo "删除镜像："
    docker compose images
    docker rmi -f $images 2>/dev/null || echo "部分镜像删除失败（可能已被其他操作删除）"
fi

# 额外清理：删除可能残留的以项目名称为标签的镜像
echo "步骤3: 清理残留镜像..."
docker images --filter "reference=*${PROJECT_NAME}*" --format "{{.ID}}" | xargs -r docker rmi -f 2>/dev/null

# 新增步骤：根据关键字强制删除镜像
echo "步骤4: 强制删除包含关键字的镜像..."
KEYWORDS=("astra-app" "astra-frontend" "astra-mysql")

for keyword in "${KEYWORDS[@]}"; do
    echo "查找包含关键字 '${keyword}' 的镜像..."
    # 查找镜像ID
    image_ids=$(docker images --format "{{.ID}} {{.Repository}}" | grep -i "$keyword" | awk '{print $1}' | sort | uniq)

    if [ -n "$image_ids" ]; then
        echo "找到包含关键字 '${keyword}' 的镜像，正在强制删除："
        # 显示要删除的镜像详情
        docker images | grep -i "$keyword"
        # 强制删除镜像
        echo "$image_ids" | xargs -r docker rmi -f 2>/dev/null && echo "已删除包含关键字 '${keyword}' 的镜像" || echo "删除包含关键字 '${keyword}' 的镜像时出现问题"
    else
        echo "未找到包含关键字 '${keyword}' 的镜像"
    fi
    echo
done

# 最终确认清理完成
echo "步骤5: 最终检查..."
echo "剩余容器:"
docker ps -a --filter "name=${PROJECT_NAME}" --format "table {{.Names}}\t{{.Status}}"

echo "剩余镜像:"
docker images --filter "reference=*${PROJECT_NAME}*" --format "table {{.Repository}}:{{.Tag}}"

# 额外显示包含关键字的镜像
echo "包含关键字的剩余镜像:"
for keyword in "${KEYWORDS[@]}"; do
    remaining=$(docker images | grep -i "$keyword")
    if [ -n "$remaining" ]; then
        echo "关键字 '${keyword}':"
        echo "$remaining"
    fi
done

echo "卸载完成！所有相关容器、网络、卷和镜像已清理"
