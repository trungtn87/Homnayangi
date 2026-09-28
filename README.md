# Hôm nay ăn gì?

Ứng dụng Flutter chọn thực đơn theo kiểu **slot machine 3 cột**:

- Món chính
- Món phụ
- Canh

Người dùng tự thêm món, bật/tắt món nào được tham gia quay, quay một lần để nhận đủ 3 món, xem ô **Tổng hợp thực đơn**, rồi lưu kết quả vào lịch sử.

## Tính năng hiện có

- Vòng quay 3 reel dừng lần lượt để tạo cảm giác như máy slot.
- Kho món chia 3 nhóm: món chính, món phụ, canh.
- Thêm / sửa / xóa món.
- Bật / tắt món mà không cần xóa.
- Lưu dữ liệu hoàn toàn trên điện thoại bằng SharedPreferences.
- Ô tổng hợp kết quả ngay sau khi quay.
- Chốt thực đơn vào lịch sử.
- Xem và xóa từng thực đơn cũ.
- Có dữ liệu mẫu để chạy thử ngay lần đầu.
- GitHub Actions kiểm tra analyze + test.
- Workflow thủ công để build APK release.

## Chạy trên máy

Yêu cầu đã cài Flutter SDK.

```bash
git clone https://github.com/trungtn87/Homnayangi.git
cd Homnayangi
flutter pub get
flutter create . --platforms=android --project-name=hom_nay_an_gi --org=com.trungtn87
flutter run
```

Lệnh `flutter create` chỉ tạo phần host Android còn thiếu; code ứng dụng trong `lib/` được giữ nguyên.

## Build APK

```bash
flutter build apk --release
```

APK nằm tại:

```text
build/app/outputs/flutter-apk/app-release.apk
```

Hoặc vào **GitHub → Actions → Build Android APK → Run workflow**. Sau khi workflow chạy xong, tải artifact `hom-nay-an-gi-apk`.

## Cấu trúc chính

```text
lib/
├── data/
│   └── local_store.dart
├── models/
│   ├── dish.dart
│   └── meal.dart
├── screens/
│   ├── root_screen.dart
│   ├── home_screen.dart
│   ├── dish_library_screen.dart
│   ├── dish_list_screen.dart
│   └── history_screen.dart
├── services/
│   └── meal_randomizer.dart
├── state/
│   └── app_controller.dart
├── widgets/
│   ├── slot_reel.dart
│   └── meal_summary_card.dart
├── app.dart
└── main.dart
```

## Nguyên tắc bản v0.1

Bản này cố ý giữ đơn giản: không tài khoản, không cloud, không quảng cáo, không công thức nấu ăn, không backend. Mục tiêu là một app mở lên có thể dùng ngay và dễ phát triển tiếp.
