# Sales Dashboard — BigQuery

Dashboard หน้าเดียว (HTML) แสดงข้อมูลยอดขายจากตาราง BigQuery
`futuretech-468203.sales_data.sale_transaction` หน้าตาแบบ Looker Studio
(KPI scorecard, กราฟเส้นตามเวลา, bar/pie chart, ตารางข้อมูล)

เชื่อมต่อ BigQuery จากเบราว์เซอร์โดยตรงผ่าน Google Identity Services (OAuth)
ผู้ใช้ล็อกอินด้วยบัญชี Google ของตัวเอง — ไม่มีการเก็บ secret ไว้ในไฟล์

## ไฟล์ในโปรเจกต์

| ไฟล์ | หน้าที่ |
|------|---------|
| `sales-dashboard.html` | ตัว dashboard หลัก (มีทุกอย่างในไฟล์เดียว) |
| `index.html` | หน้าแรก เด้งไป `sales-dashboard.html` อัตโนมัติ |
| `serve.ps1` | static server สำหรับเทสต์ในเครื่อง (PowerShell ล้วน ไม่ต้องลงอะไร) |

## วิธีใช้งาน (หลัง deploy)

เปิดลิงก์ GitHub Pages แล้วกดปุ่ม **เข้าสู่ระบบ Google** มุมขวาบน
ระบบจะอ่าน schema ของตารางเองอัตโนมัติ และแสดงข้อมูลจริง (LIVE · BigQuery)
หากเดาคอลัมน์ผิด แก้ได้จากดรอปดาวน์ด้านบน (วันที่ / ยอดเงิน / หมวดหมู่)

โหมด **DEMO** จะแสดงข้อมูลตัวอย่างให้ดูหน้าตาก่อนล็อกอิน

## การตั้งค่าครั้งแรก (ทำครั้งเดียว)

1. **GitHub Pages** — repo Settings → Pages → Source: `Deploy from a branch` → `main` / `/(root)`
2. **เปิด BigQuery API** ในโปรเจกต์ `futuretech-468203`
3. **OAuth Client ID** (Web application) → เพิ่ม Authorized JavaScript origin:
   `https://buraphiphopsmp-lgtm.github.io`
4. **OAuth consent screen** = External → เพิ่มอีเมลผู้ใช้ทุกคนใน **Test users**

## เทสต์ในเครื่อง

```powershell
powershell -ExecutionPolicy Bypass -File serve.ps1
```
แล้วเปิด http://localhost:8080/sales-dashboard.html
(ต้องเพิ่ม `http://localhost:8080` ใน Authorized JavaScript origins ด้วย)
