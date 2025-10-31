FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-runtime

WORKDIR /app

# Cài thêm thư viện cần thiết
RUN apt-get update && apt-get install -y git libgl1-mesa-glx

# Clone repo
RUN git clone https://github.com/hokimtam/IDM-VTON.git .

# Copy requirements.txt
COPY requirements.txt .

# Cài các package theo phiên bản đã fix
RUN pip install --no-cache-dir -r requirements.txt

# Copy handler
COPY handler.py .

CMD ["python", "-u", "handler.py"]
