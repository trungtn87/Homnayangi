import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/dish.dart';
import '../models/meal.dart';
import '../utils/text_normalizer.dart';

class LocalStore {
  static const _dishesKey = 'dishes_v1';
  static const _historyKey = 'meal_history_v1';

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  Future<List<Dish>> loadDishes() async {
    final raw = await _prefs.getString(_dishesKey);
    if (raw == null || raw.isEmpty) return _defaultDishes();

    final decoded = jsonDecode(raw) as List<dynamic>;
    final dishes = decoded
        .map((item) => Dish.fromJson(item as Map<String, dynamic>))
        .toList();

    var changed = false;
    final normalized = dishes.map((dish) {
      final name = normalizeUserText(dish.name);
      if (name != dish.name) changed = true;
      return dish.copyWith(name: name);
    }).toList();

    if (changed) await saveDishes(normalized);
    return normalized;
  }

  Future<void> saveDishes(List<Dish> dishes) async {
    await _prefs.setString(
      _dishesKey,
      jsonEncode(dishes.map((dish) => dish.toJson()).toList()),
    );
  }

  Future<List<Meal>> loadHistory() async {
    final raw = await _prefs.getString(_historyKey);
    if (raw == null || raw.isEmpty) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    final history = decoded
        .map((item) => Meal.fromJson(item as Map<String, dynamic>))
        .toList();

    var changed = false;
    final normalized = history.map((meal) {
      final mainDish = normalizeUserText(meal.mainDish);
      final sideDish = normalizeUserText(meal.sideDish);
      final soup = normalizeUserText(meal.soup);

      if (mainDish != meal.mainDish ||
          sideDish != meal.sideDish ||
          soup != meal.soup) {
        changed = true;
      }

      return Meal(
        id: meal.id,
        mainDish: mainDish,
        sideDish: sideDish,
        soup: soup,
        createdAt: meal.createdAt,
      );
    }).toList();

    if (changed) await saveHistory(normalized);
    return normalized;
  }

  Future<void> saveHistory(List<Meal> history) async {
    await _prefs.setString(
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
