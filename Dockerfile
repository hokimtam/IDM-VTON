FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-runtime

WORKDIR /app

# Cài gói phụ thuộc hệ thống
RUN apt-get update && apt-get install -y git libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*

# Clone source IDM-VTON
RUN git clone https://github.com/hokimtam/IDM-VTON.git .

# Copy file requirements
COPY requirements.txt .

# ⚡ Gỡ bản huggingface_hub cũ và cài từng bước (tránh conflict)
RUN pip uninstall -y huggingface_hub || true
RUN pip install --no-cache-dir setuptools==68.0.0 wheel==0.41.2

# ⚙️ Cài các package chính theo đúng version ổn định
RUN pip install --no-cache-dir \
    huggingface_hub==0.17.3 \
    diffusers==0.24.0 \
    transformers==4.34.1 \
    accelerate==0.25.0 \
    safetensors==0.4.2 \
    Pillow==10.0.0 \
    torch==2.1.0 \
    torchvision==0.15.0 \
    opencv-python==4.9.0.80 \
    tqdm==4.66.1 \
    gradio==4.0.0

# Sau cùng mới cài req còn lại để tránh version bump
RUN pip install --no-cache-dir -r requirements.txt --no-deps

# Copy handler
COPY handler.py .

CMD ["python", "-u", "handler.py"]
