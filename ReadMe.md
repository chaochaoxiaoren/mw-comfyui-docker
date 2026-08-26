# 构建
docker build -t mw-comfyui:0.0.2 .

# 容器
docker compose up -d
docker compose logs -f comfyui
docker compose down