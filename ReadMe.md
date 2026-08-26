# 构建
构建操作放在github，由github action打包镜像，只有打包tag的时候触发，tag是什么版本镜像就是什么版本

# 容器
```bash
docker compose up -d 
docker compose logs -f comfyui 
docker compose down 
```
