import 'dart:math';

import '../models/dish.dart';

class MealSelection {
  const MealSelection({
    required this.mainDish,
    required this.sideDish,
    required this.soup,
  });

  final Dish mainDish;
  final Dish sideDish;
  final Dish soup;
}

class MealRandomizer {
  MealRandomizer({Random? random}) : _random = random ?? Random();

  final Random _random;

  Dish pick(List<Dish> dishes, DishCategory category) {
    final candidates = dishes
        .where((dish) => dish.category == category && dish.enabled)
        .toList();

    if (candidates.isEmpty) {
      throw StateError('Không có món đang bật trong nhóm ' + category.label + '.');
    }

    return candidates[_random.nextInt(candidates.length)];
  }

  MealSelection generate(List<Dish> dishes) {
    return MealSelection(
      mainDish: pick(dishes, DishCategory.main),
      sideDish: pick(dishes, DishCategory.side),
      soup: pick(dishes, DishCategory.soup),
    );
  }
}
