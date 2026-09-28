#!/usr/bin/env bash
set -euo pipefail

flutter pub get

if [ ! -d "android" ]; then
  flutter create .     --empty     --platforms=android     --project-name=hom_nay_an_gi     --org=com.trungtn87
  rm -f test/widget_test.dart
fi

flutter pub get
flutter analyze
flutter test

echo "Android project is ready."
echo "Run: flutter run"
echo "Build APK: flutter build apk --release"
