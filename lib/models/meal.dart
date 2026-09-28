class Meal {
  const Meal({
    required this.id,
    required this.mainDish,
    required this.sideDish,
    required this.soup,
    required this.createdAt,
  });

  final String id;
  final String mainDish;
  final String sideDish;
  final String soup;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'mainDish': mainDish,
        'sideDish': sideDish,
        'soup': soup,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] as String,
      mainDish: json['mainDish'] as String,
      sideDish: json['sideDish'] as String,
      soup: json['soup'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
