import 'package:flutter/material.dart';

import 'app.dart';
import 'data/local_store.dart';
import 'state/app_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = AppController(LocalStore());
  await controller.load();
  runApp(MealSpinnerApp(controller: controller));
}
