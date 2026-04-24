# Use Case 1: API Routing & Versioning (แยกเส้นทางตาม Service)

## ใช้เมื่อคุณมี Microservices หลายตัว และต้องการรวมไว้ใน URL เดียวกัน หรือต้องการแยกเวอร์ชันของ API (v1, v2)

### Logic: ถ้าเรียก /users ให้ไปหา Service A, ถ้าเรียก /orders ให้ไปหา Service B

```
http {
    upstream user_service { server 10.0.0.1:8001; }
    upstream order_service { server 10.0.0.2:8002; }

    server {
        listen 80;
        server_name myapp.com;

        # เส้นทางสำหรับ User Service v1
        location /v1/users/ {
            proxy_pass http://user_service;
        }

        # เส้นทางสำหรับ Order Service v1
        location /v1/orders/ {
            proxy_pass http://order_service;
        }
    }
}
```

---

# Use Case 2: Security Filtering (ตรวจสอบ API Key ก่อนเข้า)

## ใช้เพื่อป้องกันไม่ให้บุคคลภายนอกที่ไม่มี Key เข้าถึง Backend ของเรา ช่วยลดภาระของ Backend ไม่ต้องเขียน Code ตรวจสอบเอง

### Logic: ตรวจสอบ Header X-API-KEY ถ้าไม่ตรงให้ส่ง 403 Forbidden ทันที

```
server {
    listen 80;
    server_name myapp.com;

    location / {
        # ตรวจสอบ API Key เบื้องต้น
        if ($http_x_api_key != "secret-api-key-12345") {
            return 403 '{"error": "Unauthorized Access"}';
            add_header Content-Type application/json;
        }

        proxy_pass http://backend_cluster;
        proxy_set_header Host $host;
    }
}
```

---

# Use Case 3: Rate Limiting (ป้องกันการเรียกใช้งานถี่เกินไป)

## ใช้ป้องกันการโดน Brute Force หรือป้องกันระบบล่มจากการโดนยิงถล่ม (DDoS)

### Logic: จำกัดให้ 1 IP สามารถเรียก API ได้เพียง 5 ครั้งต่อวินาที (5 requests per second)

```
http {
    # สร้างโซนสำหรับเก็บข้อมูล IP และจำกัดที่ 5 ครั้ง/วินาที
    limit_req_zone $binary_remote_addr zone=api_limit:10m rate=5r/s;

    server {
        listen 80;
        server_name myapp.com;

        location /api/ {
            # นำ Rate Limit มาใช้ใน Block นี้
            # burst=10 คือยอมให้เกินได้นิดหน่อยแต่ต้องรอคิว
            # nodelay คือถ้าเกินแล้วให้ตัดทันทีไม่ต้องรอ
            limit_req zone=api_limit burst=10 nodelay;

            proxy_pass http://backend_cluster;
        }
        
        # จัดการข้อความเมื่อโดนบล็อก (Error 503)
        error_page 503 /limit_exceeded.json;
    }
}
```


