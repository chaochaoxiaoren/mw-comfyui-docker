# 基础镜像
FROM pytorch/pytorch:2.5.1-cuda12.4-cudnn9-runtime

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    COMFYUI_PATH=/ComfyUI \
    COMFY_PORT=8188 \
    COMFY_GPU_MODE=auto

WORKDIR /ComfyUI

# 1.系统依赖层
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

# 2. 拉取ComfyUI v0.33.3 release版本，浅克隆
RUN git clone --depth 1 --branch v0.33.3 https://github.com/comfyanonymous/ComfyUI.git .

# 3.ComfyUI本体python依赖，自动读取上面pip.conf走清华源
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# ==========复制外部脚本到镜像内==========
COPY start.sh /ComfyUI/start.sh
RUN chmod +x /ComfyUI/start.sh

EXPOSE ${COMFY_PORT}

CMD ["/ComfyUI/start.sh"]
