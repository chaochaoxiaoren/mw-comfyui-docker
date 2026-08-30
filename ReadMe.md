使用Nvidia 20及以上显卡
# 本地调试
```
docker build -t mw-comfyui-docker:local-dev .

# 创建容器，立马执行comfyui，验证容器是否可用
docker run -it --gpus all -e COMFY_GPU_MODE=lowvram -p 8188:8188 -v ./models:/ComfyUI/models -v ./custom_nodes:/ComfyUI/custom_nodes -v ./output:/ComfyUI/output -v ./workflows:/ComfyUI/user/default/workflows --rm mw-comfyui-docker:local-dev

# 只进容器不运行start.sh，用于查看文件和按需处理
docker run -it --gpus all -e COMFY_GPU_MODE=lowvram -p 8188:8188 -v ./models:/ComfyUI/models -v ./custom_nodes:/ComfyUI/custom_nodes -v ./output:/ComfyUI/output -v ./workflows:/ComfyUI/user/default/workflows --rm --entrypoint bash mw-comfyui-docker:local-dev
# 直接运行
./start.sh

# 容器内校验命令
python -c "import torch;print(torch.__version__, torch.version.cuda, torch.cuda.is_available())"
python -c "import cv2;print(cv2.__version__)"
ls /ComfyUI/custom_nodes
ls /ComfyUI/user/default/workflows
```

# github actions构建
构建操作放在github，由github action打包镜像，只有打包tag的时候触发，tag是什么版本镜像就是什么版本

# 容器
```bash
docker compose up -d 
docker compose logs -f comfyui 
docker compose down 
```
