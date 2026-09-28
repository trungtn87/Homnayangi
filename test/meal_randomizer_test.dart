import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:hom_nay_an_gi/models/dish.dart';
import 'package:hom_nay_an_gi/services/meal_randomizer.dart';

void main() {
  test('generate returns one enabled dish from each category', () {
    final dishes = [
      const Dish(id: 'm1', name: 'M1', category: DishCategory.main),
      const Dish(
        id: 'm2',
        name: 'Disabled',
        category: DishCategory.main,
        enabled: false,
      ),
      const Dish(id: 's1', name: 'S1', category: DishCategory.side),
      const Dish(id: 'c1', name: 'C1', category: DishCategory.soup),
    ];

    final result = MealRandomizer(random: Random(1)).generate(dishes);

    expect(result.mainDish.id, 'm1');
    expect(result.sideDish.id, 's1');
    expect(result.soup.id, 'c1');
  });

  test('pick throws when a category has no enabled dish', () {
    final randomizer = MealRandomizer(random: Random(1));
    final dishes = [
      const Dish(
        id: 'm1',
        name: 'M1',
        category: DishCategory.main,
        enabled: false,
      ),
    ];

    expect(
      () => randomizer.pick(dishes, DishCategory.main),
      throwsStateError,
    );
  });
}
