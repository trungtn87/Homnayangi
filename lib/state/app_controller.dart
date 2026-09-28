import 'package:flutter/foundation.dart';

import '../data/local_store.dart';
import '../models/dish.dart';
import '../models/meal.dart';
import '../services/meal_randomizer.dart';

class AppController extends ChangeNotifier {
  AppController(this._store);

  final LocalStore _store;
  final MealRandomizer randomizer = MealRandomizer();

  List<Dish> _dishes = [];
  List<Meal> _history = [];

  List<Dish> get dishes => List.unmodifiable(_dishes);
  List<Meal> get history => List.unmodifiable(_history);

  Future<void> load() async {
    _dishes = await _store.loadDishes();
    _history = await _store.loadHistory();
    _history.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  List<Dish> dishesFor(DishCategory category) =>
      _dishes.where((dish) => dish.category == category).toList();

  List<Dish> enabledDishesFor(DishCategory category) => _dishes
      .where((dish) => dish.category == category && dish.enabled)
      .toList();

  bool get canSpin => DishCategory.values.every(
        (category) => enabledDishesFor(category).isNotEmpty,
      );

  Future<void> addDish(String name, DishCategory category) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    _dishes.add(
      Dish(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: trimmed,
        category: category,
      ),
    );
    await _persistDishes();
  }

  Future<void> updateDish(Dish updated) async {
    final index = _dishes.indexWhere((dish) => dish.id == updated.id);
    if (index == -1) return;
    _dishes[index] = updated;
    await _persistDishes();
  }

  Future<void> deleteDish(String id) async {
    _dishes.removeWhere((dish) => dish.id == id);
    await _persistDishes();
  }

  Future<void> toggleDish(Dish dish, bool enabled) async {
    await updateDish(dish.copyWith(enabled: enabled));
  }

  Future<void> saveMeal(MealSelection selection) async {
    final meal = Meal(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      mainDish: selection.mainDish.name,
      sideDish: selection.sideDish.name,
      soup: selection.soup.name,
      createdAt: DateTime.now(),
    );
    _history.insert(0, meal);
    await _store.saveHistory(_history);
    notifyListeners();
  }

  Future<void> deleteMeal(String id) async {
    _history.removeWhere((meal) => meal.id == id);
    await _store.saveHistory(_history);
    notifyListeners();
  }

  Future<void> _persistDishes() async {
    await _store.saveDishes(_dishes);
    notifyListeners();
  }
}
