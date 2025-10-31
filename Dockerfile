# ===============================
# ✅ BASE IMAGE ỔN ĐỊNH CHO GPU
# ===============================
FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-runtime

WORKDIR /app

# ===============================
# 🧩 CÀI GÓI HỆ THỐNG
# ===============================
RUN apt-get update && \
    apt-get install -y --no-install-recommends git libgl1-mesa-glx && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ===============================
# 📦 CLONE SOURCE IDM-VTON
# ===============================
RUN git clone https://github.com/hokimtam/IDM-VTON.git .

# ===============================
# 📦 CHUẨN BỊ ENV
# ===============================
COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel --no-cache-dir

# ===============================
# 🚀 CÀI PACKAGE CHÍNH THEO THỨ TỰ
# ===============================

# Nhóm 1 — HuggingFace và Diffusers
RUN pip install --no-cache-dir \
    huggingface_hub==0.17.3 \
    diffusers==0.24.0 \
    transformers==4.34.1

# Nhóm 2 — Accelerate và các thư viện phụ
RUN pip install --no-cache-dir \
    accelerate==0.25.0 \
    safetensors==0.4.2 \
    Pillow==10.0.0

# Nhóm 3 — Torch và Vision
RUN pip install --no-cache-dir \
    torch==2.1.0 \
    torchvision==0.15.0 \
    opencv-python==4.9.0.80 \
    tqdm==4.66.1 \
    gradio==4.0.0

# Cài phần còn lại trong requirements.txt (không kéo dependency mới)
RUN pip install --no-cache-dir -r requirements.txt --no-deps || true

# ===============================
# 🧠 DEBUG: KIỂM TRA PHIÊN BẢN
# ===============================
RUN python -m pip show huggingface_hub | grep Version

# ===============================
# 🧩 COPY FILE HANDLER
# ===============================
COPY handler.py .

# ===============================
# ▶️ ENTRYPOINT
# ===============================
CMD ["python", "-u", "handler.py"]
