# HƯỚNG DẪN CẤU HÌNH & TRIỂN KHAI STANDALONE PREVIEW (ANGULAR + JAVA SERVLET)

Tài liệu này hướng dẫn chi tiết cách cấu trúc, cấu hình và triển khai trang xem trước độc lập (Standalone Landing Page Preview) chạy ngoại tuyến (offline) kết hợp giữa **Angular** và **Java Servlet** trên Apache Tomcat hoặc WebOTX.

---

## 🏢 1. Tổng quan Kiến trúc Tách biệt (Decoupled Architecture)

Hệ thống được thiết kế theo nguyên tắc **Tách biệt vai trò (Separation of Concerns)** tối đa:
* **Angular (Frontend - Client)**: Đảm nhận 100% logic giao diện, căn chỉnh CSS, và đọc tham số dữ liệu từ `localStorage` để tự động render lên màn hình.
* **Java Servlet (Backend - Server)**: Đóng vai trò là một **máy chủ phân phối file tĩnh (Static Host)**. Tomcat chỉ cần phục vụ trực tiếp các file HTML/CSS/JS đã biên dịch của Angular ra ngoài, giúp máy chủ Servlet cực kỳ nhẹ, an toàn và không bị quá tải.

### 🔄 Luồng truyền nhận dữ liệu qua LocalStorage
Để tránh giới hạn ký tự của URL (khi nội dung nhập liệu quá dài gây lỗi Tomcat 400/414), hệ thống truyền dữ liệu qua bộ nhớ cục bộ trình duyệt:

```
[Servlet JSP (Cửa sổ cha)]
   │
   ├─► 1. Lưu JSON: localStorage.setItem('preview_data', JSON.stringify({title, desc}))
   │
   └─► 2. Mở popup nổi (window.open) tới endpoint: /preview-landing
            │
            ▼
[Java Servlet (Tomcat Redirect)] ──► Chuyển hướng 302 bảo toàn tham số về /preview-landing/browser/
                                           │
                                           ▼
[Angular Preview (Cửa sổ con)]
   │
   ├─► 1. Đọc bộ nhớ: localStorage.getItem('preview_data') ──► Đổ động lên Signals
   │
   └─► 2. (Dự phòng): Nếu localStorage trống ──► Trích xuất URL query parameters làm fallback
```
* **Điều kiện hoạt động**: Cả trang Servlet cha và trang Angular con đều chạy chung Origin (giao thức `http`, máy chủ `localhost`, cổng `8080`), do đó Same-Origin Policy của trình duyệt cho phép hai cửa sổ chia sẻ chung vùng nhớ `localStorage` một cách an toàn.

---

## 📂 2. Cơ cấu Dự án Standalone Landing Page (`projects/landing-preview/`)

Ứng dụng Landing độc lập nằm trong thư mục `projects/landing-preview/` thuộc Workspace Angular:
* **Mô tả**: Chỉ chứa duy nhất mã nguồn, HTML và CSS của trang Landing Page mẫu.
* **Mục đích**: Loại bỏ hoàn toàn các thư viện định tuyến và code dư thừa, giúp bundle size cực kỳ nhẹ (chỉ ~107KB), tối ưu tốc độ tải offline.
* **Đầu ra**: Xuất bản trực tiếp vào thư mục `/preview-landing/browser/` của Java Servlet.

---

## ⚙️ 3. Các Điểm Cấu Hình Cần Thiết Ở Phía Angular

Để ứng dụng Angular hoạt động trơn tru trong môi trường offline của Java Servlet, lập trình viên cần lưu ý 3 cấu hình sau:

### 3.1. Cấu hình Đường dẫn tương đối (`baseHref: "./"`)
Để tài nguyên tĩnh (JS, CSS) được phân giải tương đối theo thư mục cha:
* Khai báo trong `index.html` của dự án `landing-preview`:
  ```html
  <base href="./" />
  ```

### 3.2. Cấu hình Output Path trỏ trực tiếp sang Java Webapp
Trong file [angular.json](file:///Users/thucduy/Public/dev/java-servlet/angular-app/angular.json), chuyển đường dẫn xuất bản đầu ra thẳng tới thư mục tĩnh của Java Servlet:
```json
"outputPath": "../servlet-web/src/main/webapp/preview-landing"
```

### 3.3. Xử lý Tránh lỗi biên dịch SSR/SSG (Window Check)
Vì Angular biên dịch tĩnh (Prerendering) chạy code giả lập trên môi trường Node.js (không có đối tượng `window` và `document`), mọi thao tác gọi `window` hay `document` trực tiếp trong Component cần được bọc trong điều kiện:
```typescript
if (typeof window !== 'undefined') {
  // Thực thi các mã nguồn dành riêng cho trình duyệt tại đây
  const params = new URLSearchParams(window.location.search);
}
```

---

## ☕ 4. Các Điểm Cấu Hình Ở Phía Java Servlet

### 4.1. Khai báo Welcome Files (`web.xml`)
Đảm bảo Tomcat tự động phục vụ file `index.html` khi truy cập vào thư mục tĩnh:
```xml
<welcome-file-list>
    <welcome-file>home.jsp</welcome-file>
    <welcome-file-list>index.html</welcome-file-list>
</welcome-file-list>
```

### 4.2. Viết Servlet Chuyển hướng 302 bảo toàn Tham số
Để trình duyệt phân giải đúng relative path `./` của Angular, Servlet phải redirect từ `/preview-landing` sang `/preview-landing/browser/` và bảo toàn chuỗi tham số:
```java
@WebServlet(name = "LandingPreviewServlet", urlPatterns = "/preview-landing", loadOnStartup = 1)
public class LandingPreviewServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String contextPath = req.getContextPath();
        String queryString = req.getQueryString();
        String redirectUrl = contextPath + "/preview-landing/browser/";
        if (queryString != null && !queryString.isEmpty()) {
            redirectUrl += "?" + queryString;
        }
        resp.sendRedirect(redirectUrl);
    }
}
```

---

## 🚀 5. Quy trình Biên dịch & Triển khai (Build & Deploy)

### Bước 1: Biên dịch mã nguồn Angular tĩnh
Mở Terminal tại thư mục `angular-app/` và chạy lệnh build:
```bash
npx ng build landing-preview
```

---

### Bước 2: Đóng gói và Deploy Java Web App (WAR)

#### 🍎 Trên macOS / 🐧 Trên Linux:
```bash
# 1. Di chuyển vào thư mục Servlet
cd ../servlet-web

# 2. Cấu hình JAVA_HOME và đóng gói bằng Maven
export JAVA_HOME=$(brew --prefix openjdk)/libexec/openjdk.jdk/Contents/Home
mvn clean package

# 3. Deploy sang thư mục webapps của Tomcat
cp target/servlet-web.war <TOMCAT_HOME>/webapps/
```

#### 💻 Trên Windows:
```cmd
:: 1. Di chuyển vào thư mục Servlet
cd ..\servlet-web

:: 2. Cấu hình JAVA_HOME và đóng gói bằng Maven
set JAVA_HOME=C:\Program Files\Java\jdk-21
mvn clean package

:: 3. Deploy sang thư mục webapps của Tomcat
copy target\servlet-web.war <TOMCAT_HOME>\webapps\
```

---

## 🔍 6. Các Đường dẫn Kiểm tra Sau khi Deploy
Khởi động máy chủ Tomcat của bạn và truy cập các đường dẫn:

1. **Trang chủ điều khiển của Servlet**:
   * URL: **`http://localhost:8080/servlet-web/`**
   * *Hành vi*: Nhập dữ liệu tùy biến vào form cấu hình ở giữa trang và bấm **Xem thử**. Hệ thống sẽ tự động mở popup nổi chứa đúng nội dung bạn đã điền.
2. **Xem thử độc lập (Trang Landing gọn nhẹ)**:
   * URL: **`http://localhost:8080/servlet-web/preview-landing`**
     (Hệ thống tự động redirect sang `/preview-landing/browser/` và lấy dữ liệu hiển thị).

---

## 🚀 7. Quy Trình Thêm Một Trang Preview Mới (Scaling Strategy)

Khi bạn muốn bổ sung thêm các trang xem thử độc lập mới (ví dụ: `preview-dashboard`, `preview-profile`, v.v.) vào hệ thống, bạn chỉ cần thực hiện 4 bước chuẩn hóa sau:

### Bước 1: Khởi tạo dự án con mới trong Angular
Mở Terminal tại thư mục `angular-app/` và chạy lệnh tạo ứng dụng con (Ví dụ tạo trang Profile `preview-profile`):
```bash
npx ng generate application preview-profile --routing=false --ssr=false --style=css --skip-tests=true --defaults
```
* **Phát triển giao diện**: Viết code giao diện cho trang mới trong thư mục `projects/preview-profile/src/app/`.
* **Cấu hình relative**: Đổi thẻ base href trong file `projects/preview-profile/src/index.html` thành `<base href="./" />`.

### Bước 2: Cấu hình Output Path cho dự án mới
Trong file `angular.json`, tìm đến cấu hình của dự án con vừa sinh ra (`preview-profile`) và thay đổi đường dẫn xuất bản trỏ về thư mục tĩnh riêng biệt trong Java Servlet:
```json
"outputPath": "../servlet-web/src/main/webapp/preview-profile"
```

### Bước 3: Tạo Servlet Java điều hướng tương ứng
Tạo một file Java Servlet mới (ví dụ: `ProfilePreviewServlet.java` tại `com.example.web`) để đón nhận đường dẫn truy cập và thực hiện redirect 302 bảo toàn tham số về thư mục tĩnh `/browser/`:
```java
@WebServlet(name = "ProfilePreviewServlet", urlPatterns = "/preview-profile", loadOnStartup = 1)
public class ProfilePreviewServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String contextPath = req.getContextPath();
        String queryString = req.getQueryString();
        String redirectUrl = contextPath + "/preview-profile/browser/";
        if (queryString != null && !queryString.isEmpty()) {
            redirectUrl += "?" + queryString;
        }
        resp.sendRedirect(redirectUrl);
    }
}
```

### Bước 4: Tích hợp nút bấm trên trang chủ Java Servlet (`home.jsp`)
Tại `home.jsp`, bạn bổ sung lựa chọn mẫu hoặc các nút xem thử tương ứng:
* Ghi dữ liệu nhập vào `localStorage`:
  ```javascript
  localStorage.setItem('preview_data', JSON.stringify(previewData));
  ```
* Gọi `window.open` trỏ tới servlet của trang bạn muốn mở:
  * Nếu mở Landing: Gọi URL `${ctx}/preview-landing`
  * Nếu mở Profile mới: Gọi URL `${ctx}/preview-profile`

