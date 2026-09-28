import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/dish.dart';
import '../models/meal.dart';

class LocalStore {
  static const _dishesKey = 'dishes_v1';
  static const _historyKey = 'meal_history_v1';

  Future<List<Dish>> loadDishes() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_dishesKey);
    if (raw == null || raw.isEmpty) return _defaultDishes();

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Dish.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveDishes(List<Dish> dishes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _dishesKey,
      jsonEncode(dishes.map((dish) => dish.toJson()).toList()),
    );
  }

  Future<List<Meal>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_historyKey);
    if (raw == null || raw.isEmpty) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Meal.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveHistory(List<Meal> history) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _historyKey,
      jsonEncode(history.map((meal) => meal.toJson()).toList()),
    );
  }

  List<Dish> _defaultDishes() {
    const seed = <(String, DishCategory)>[
      ('Thịt kho', DishCategory.main),
      ('Gà rang gừng', DishCategory.main),
      ('Cá rán', DishCategory.main),
      ('Sườn xào chua ngọt', DishCategory.main),
      ('Thịt luộc', DishCategory.main),
      ('Rau muống xào', DishCategory.side),
      ('Đậu rán', DishCategory.side),
      ('Trứng chiên', DishCategory.side),
      ('Su su xào tỏi', DishCategory.side),
      ('Dưa chuột', DishCategory.side),
      ('Canh bí', DishCategory.soup),
      ('Canh rau ngót', DishCategory.soup),
      ('Canh cải', DishCategory.soup),
      ('Canh chua', DishCategory.soup),
      ('Canh khoai tây', DishCategory.soup),
    ];

    return [
      for (var index = 0; index < seed.length; index++)
        Dish(
          id: 'seed_$index',
          name: seed[index].$1,
          category: seed[index].$2,
        ),
    ];
  }
}
