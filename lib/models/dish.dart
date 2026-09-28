enum DishCategory {
  main,
  side,
  soup;

  String get label => switch (this) {
        DishCategory.main => 'Món chính',
        DishCategory.side => 'Món phụ',
        DishCategory.soup => 'Canh',
      };

  String get emoji => switch (this) {
        DishCategory.main => '🍖',
        DishCategory.side => '🥬',
        DishCategory.soup => '🍲',
      };

  int get tintValue => switch (this) {
        DishCategory.main => 0xFFFFEFEF,
        DishCategory.side => 0xFFEDF8ED,
        DishCategory.soup => 0xFFEAF3FF,
      };
}

class Dish {
  const Dish({
    required this.id,
    required this.name,
    required this.category,
    this.enabled = true,
  });

  final String id;
  final String name;
  final DishCategory category;
  final bool enabled;

  Dish copyWith({
    String? id,
    String? name,
    DishCategory? category,
    bool? enabled,
  }) {
    return Dish(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category.name,
        'enabled': enabled,
      };

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'] as String,
      name: json['name'] as String,
      category: DishCategory.values.byName(json['category'] as String),
      enabled: json['enabled'] as bool? ?? true,
    );
  }
}
