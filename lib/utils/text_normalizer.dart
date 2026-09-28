import 'package:unorm_dart/unorm_dart.dart' as unorm;

String normalizeUserText(String value) {
  final normalized = unorm.nfc(value);
  return normalized.replaceAll(RegExp(r'\s+'), ' ').trim();
}
