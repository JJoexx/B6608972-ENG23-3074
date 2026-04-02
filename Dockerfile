# 1. ใช้ Nginx เป็นพื้นฐาน
FROM nginx:alpine

# 2. ก๊อปปี้หน้าม่วงของคุณ (index.html) ไปวางในที่ที่ Nginx จะหาเจอ
# ตรวจสอบชื่อไฟล์หน้าม่วงของคุณด้วยนะว่าชื่อ index.html หรือเปล่า
COPY index.html /usr/share/nginx/html/index.html

# 3. เปิด Port 80
EXPOSE 80