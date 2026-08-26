# 基础镜像：PyTorch2.4 CUDA12.4 cudnn9‑devel
FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn9-devel

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

# ========== pip 清华源全局配置 ==========
RUN mkdir -p /root/.pip && cat > /root/.pip/pip.conf <<EOF
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
trusted-host = pypi.tuna.tsinghua.edu.cn
EOF

# 2. 拉取ComfyUI v0.33.3 release版本，浅克隆
RUN git clone --depth 1 --branch v0.33.3 https://github.com/comfyanonymous/ComfyUI.git .

# 3.ComfyUI本体python依赖，自动读取上面pip.conf走清华源
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# 4.自定义节点插件
RUN mkdir -p custom_nodes && cd custom_nodes && \
    git clone https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet.git && \
    git clone https://github.com/kijai/ComfyUI-KJNodes.git && \
    cd ComfyUI-KJNodes && pip install -r requirements.txt && cd .. && \
    git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus.git && \
    git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git && \
    cd ComfyUI-Manager && pip install -r requirements.txt

# 预创建目录
RUN mkdir -p \
    models/checkpoints \
    models/controlnet \
    models/loras \
    models/vae \
    models/clip \
    models/ipadapter \
    output \
    temp

# ==========复制外部脚本到镜像内==========
COPY start.sh /ComfyUI/start.sh
RUN chmod +x /ComfyUI/start.sh

EXPOSE ${COMFY_PORT}

CMD ["/ComfyUI/start.sh"]
