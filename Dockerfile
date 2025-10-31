FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-runtime

WORKDIR /app

# Cài đặt gói hệ thống cơ bản
RUN apt-get update && apt-get install -y git libgl1-mesa-glx

# Clone mã nguồn IDM-VTON
RUN git clone https://github.com/xxx/IDM-VTON.git .

# Cài đặt các thư viện Python cần thiết
RUN pip install -r requirements.txt

# Copy file handler chính cho RunPod
COPY handler.py .

# Chạy file handler.py
CMD ["python", "-u", "handler.py"]
