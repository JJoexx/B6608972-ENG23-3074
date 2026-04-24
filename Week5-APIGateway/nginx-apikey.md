# กรณีไม่ใส่ Key หรือใส่ผิด:
curl -I -H "X-API-KEY: wrong-key" http://example.com
### ผลลัพธ์: HTTP/1.1 403 Forbidden

# กรณีใส่ Key ถูกต้อง:
curl -I -H "X-API-KEY: my-super-secret-123" http://example.com
### ผลลัพธ์: HTTP/1.1 200 OK (และข้อมูลจาก Backend)
