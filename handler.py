# handler.py
import base64, io
from PIL import Image
from inference_dc import inference_main  # file inference chính của repo

def handler(event):
    person_url = event["input"]["person_url"]
    cloth_url = event["input"]["cloth_url"]

    # tải ảnh từ URL
    import requests
    person = Image.open(io.BytesIO(requests.get(person_url).content)).convert("RGB")
    cloth = Image.open(io.BytesIO(requests.get(cloth_url).content)).convert("RGB")

    # Gọi inference (tùy hàm cụ thể trong repo)
    output_img = inference_main(person, cloth)  # ví dụ

    # convert ảnh output thành base64 để trả JSON
    buf = io.BytesIO()
    output_img.save(buf, format="JPEG")
    base64_img = base64.b64encode(buf.getvalue()).decode("utf-8")

    return {"output": {"image_base64": base64_img}}
