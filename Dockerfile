# =========================
# ✅ Base image gọn nhẹ và ổn định
# =========================
FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-runtime

WORKDIR /app

# =========================
# 🧩 Cài gói hệ thống cần thiết
# =========================
RUN apt-get update && \
    apt-get install -y git libgl1-mesa-glx && \
    rm -rf /var/lib/apt/lists/*

# =========================
# 📦 Clone repo IDM-VTON
# =========================
RUN git clone https://github.com/hokimtam/IDM-VTON.git .

# =========================
# 📦 Chuẩn bị environment
# =========================
COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel --no-cache-dir

# =========================
# 🚀 Cài các gói chính theo thứ tự an toàn (chia nhỏ để tránh OOM)
# =========================
RUN pip install --no-cache-dir \
    huggingface_hub==0.17.3 \
    diffusers==0.24.0 \
    transformers==4.34.1

RUN pip install --no-cache-dir \
    accelerate==0.25.0 \
    safetensors==0.4.2 \
    Pillow==10.0.0

RUN pip install --no-cache-dir \
    torch==2.1.0 \
    torchvision==0.15.0 \
    opencv-python==4.9.0.80 \
    tqdm==4.66.1 \
    gradio==4.0.0

# Cài phần còn lại trong requirements (nếu có)
RUN pip install --no-cache-dir -r requirements.txt --no-deps || true

# Xác nhận phiên bản HuggingFace Hub (debug)
RUN python -m pip show huggingface_hub | grep Version

# =========================
# 🧠 Copy file handler
# =========================
COPY handler.py .

# =========================
# ▶️ Entry point
# =========================
CMD ["python", "-u", "handler.py"]
