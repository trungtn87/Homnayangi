import 'package:flutter/material.dart';

import '../models/dish.dart';

IconData categoryIcon(DishCategory category) => switch (category) {
      DishCategory.main => Icons.restaurant_rounded,
      DishCategory.side => Icons.eco_rounded,
      DishCategory.soup => Icons.soup_kitchen_rounded,
    };
