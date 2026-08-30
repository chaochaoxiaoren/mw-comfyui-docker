#!/bin/bash
set -e

EXTRA_ARGS="--listen 0.0.0.0 --multi-user --port ${COMFY_PORT}"

case "${COMFY_GPU_MODE}" in
high)
    EXTRA_ARGS="${EXTRA_ARGS} --gpu-only"
    ;;
lowvram)
    EXTRA_ARGS="${EXTRA_ARGS} --lowvram"
    ;;
novram)
    EXTRA_ARGS="${EXTRA_ARGS} --novram"
    ;;
cpu)
    EXTRA_ARGS="${EXTRA_ARGS} --cpu"
    ;;
auto)
    ;;
esac

echo "====================================="
echo " ComfyUI Container Boot"
echo " PORT         : ${COMFY_PORT}"
echo " GPU_MODE     : ${COMFY_GPU_MODE}"
echo " Final CMD    : python main.py ${EXTRA_ARGS}"
echo "====================================="

exec python main.py ${EXTRA_ARGS}
