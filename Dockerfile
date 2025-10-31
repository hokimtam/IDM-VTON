FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-runtime

# Làm việc trong thư mục /app
WORKDIR /app

# Cài gói phụ thuộc hệ thống
RUN apt-get update && apt-get install -y git libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*

# Clone source IDM-VTON
RUN git clone https://github.com/hokimtam/IDM-VTON.git .

# ⚡ Gỡ bỏ các bản huggingface_hub có sẵn (do base image đã có bản mới)
RUN pip uninstall -y huggingface_hub

# ⚙️ Cài đúng version cố định, KHÔNG để pip tự nâng cấp
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir huggingface_hub==0.17.3 diffusers==0.24.0 transformers==4.34.1 accelerate==0.25.0 safetensors==0.4.2 Pillow==10.0.0 && \
    pip check

# Copy file handler để RunPod dùng làm entrypoint
COPY handler.py .

# CMD phải gọi đúng file chính của bạn
CMD ["python", "-u", "handler.py"]
