# pytorch:2.7.0 CUDA12.6，使用devel镜像自带编译工具
FROM pytorch/pytorch:2.7.0-cuda12.6-cudnn9-devel

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    COMFYUI_PATH=/ComfyUI \
    COMFY_PORT=8188 \
    COMFY_GPU_MODE=auto

WORKDIR /ComfyUI

# devel镜像自带gcc/g++，仅安装图像/视频系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    wget \
    curl \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libxext6 \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch v0.33.3 https://github.com/comfyanonymous/ComfyUI.git .

RUN pip install --upgrade pip && \
    pip install -r requirements.txt && \
    pip install opencv-python

COPY start.sh /ComfyUI/start.sh
RUN chmod +x /ComfyUI/start.sh

EXPOSE ${COMFY_PORT}
CMD ["/ComfyUI/start.sh"]
